{
    This file is part of the Free Component Library (FCL)
    Copyright (c) 2024 by Michael Van Canneyt (michael@freepascal.org)

    Data Structures to generate pascal code based on OpenAPI data

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit fpopenapi.pascaltypes;

{$mode ObjFPC}{$H+}

interface

uses
{$IFDEF FPC_DOTTEDUNITS}
  System.Classes, System.SysUtils, System.Types, System.Contnrs,
{$ELSE}  
  Classes, SysUtils, Types, contnrs,
{$ENDIF}
  fpjson.schema.types,
  fpjson.schema.schema,
  fpjson.schema.pascaltypes,
  fpopenapi.objects,
  fpopenapi.types;

const
  ptAPIComponent = ptSchemaStruct;

type
  EGenAPI = Class(Exception);

  TAPIService = Class;
  TAPIServiceMethod = Class;
  TAPIData = class;

  TAPIProperty = class(TPascalPropertyData);

  { TAPITypeData }

  TAPITypeData = Class(TPascalTypeData)
  private
    FIndex: Integer;
  protected
    function CreateProperty(const aAPIName, aPascalName: string): TPascalPropertyData; override;
  public
    function AddProperty(const aApiName, aPascalName: String): TAPIProperty; reintroduce;
    // Index in openAPI #components
    Property Index : Integer Read FIndex;
  end;

  { TAPIServiceMethod }

  { TAPIServiceMethodParam }
  TParamLocation = (plQuery,plPath);

  TAPIServiceMethodParam = Class(TObject)
  private
    FArgType: TPropertyType;
    FDefaultValue: String;
    FName: String;
    FOriginalName: String;
    FParameter: TParameter;
    FTypeName: String;
    function GetAsStringValue: String;
    function Getlocation: TParamLocation;
  Public
    Constructor create(aArgType : TPropertyType; aOriginalName : String; aName : String; aTypeName : String; aParam : TParameter);
    // Argument type
    Property ArgType : TPropertyType Read FArgType;
    // Assigned pascal name
    Property Name : String Read FName;
    // Original openAPI name. Can be empty
    Property OriginalName : String Read FOriginalName;
    // Pascal type name
    Property TypeName : String Read FTypeName;
    // The OpenAPI parameter
    Property Parameter : TParameter Read FParameter;
    // Location of this parameter
    Property Location : TParamLocation Read Getlocation;
    // Pascal expression to return the parameter value as a string
    Property AsStringValue : String Read GetAsStringValue;
    // Pascal expression with default value for this parameter
    Property DefaultValue : String Read FDefaultValue Write FDefaultValue;
  end;


  TAPIServiceMethod = Class(TObject)
  private
    FBodyType: String;
    FMethodName: String;
    FOperation: TApiOperation;
    FResultCallbackType: String;
    FResultClassType: String;
    FResultDtoType: String;
    FResultType: String;
    FService: TAPIService;
    FPath : TPathItem;
    FParams : TFPObjectList;
    function GetParam(aIndex : Integer): TAPIServiceMethodParam;
    function GetParamCount: Integer;
  protected
    // override this if you want to subclass the parameter
    function CreateParam(const aType: TPascaltype; const aOriginalName, aName, aTypeName: String; aParam: TParameter     ): TAPIServiceMethodParam; virtual;
    Procedure SortParams;
  Public
    Constructor create (aOperation : TApiOperation; aPath : TPathItem; aService : TAPIService; const aMethod : String);
    Destructor Destroy; override;
    // Add a parameter
    function AddParam(const aType: TPascalType; const aOriginalName, aName, aTypeName: String; aParam: TParameter
      ): TAPIServiceMethodParam;
    // Find parameter methods by name.
    Function ParamByNAme(aOriginalName : String) : TAPIServiceMethodParam;
    // Does this class have parameters with location 'path'
    function HasPathParam: Boolean;
    // Does this class have parameters with location 'query'
    Function HasQueryParam : Boolean;
    // Does this method have parameters with default values ?
    Function HasOptionalParams : Boolean;

    // Pascal type of request body. May be empty.
    Property RequestBodyType : String Read FBodyType Write FBodyType;
    // Result type. Can be empty
    Property ResultType : String Read FResultType Write FResultType;
    // Component result class type.
    Property ResultClassType : String Read FResultClassType Write FResultClassType;
    // Component result Dto type
    Property ResultDtoType : String Read FResultDtoType Write FResultDtoType;
    // Callback type for result.
    Property ResultCallBackType : String Read FResultCallbackType write FResultCallBackType;
    // OpenAPI Operation for this method.
    Property Operation : TApiOperation Read FOperation;
    // Pascal name for the method.
    Property MethodName : String Read FMethodName;
    // Service this method belongs to.
    Property Service : TAPIService Read FService;
    // OpenAPI Path of this method.
    Property Path : TPathItem Read FPath;
    // indexed access to parameters
    Property Param[aIndex : Integer] : TAPIServiceMethodParam Read GetParam;
    // Number of parameters.
    Property ParamCount: Integer Read GetParamCount;
  end;

  TAPIService = Class(TObject)
  private
    FMethods : TFPObjectList;
    FNeedsAuthentication: Boolean;
    FServiceImplementationClassName: String;
    FServiceInterfaceName: string;
    FServiceName: string;
    FServiceParentInterface: String;
    FServiceUUID: string;
    function GetMethod(aIndex : Integer): TAPIServiceMethod;
    function GetMethodCount: Integer;
    function GetServiceImplementationClassName: String;
    function GetServiceInterfaceName: string;
    function GetServiceUUID: string;
  protected
    // Override this if you wish to create a descendant of TAPIserviceMethod
    function CreateMethod(aOperation: TAPIOperation; aPath: TPathItem; const aName: String): TAPIserviceMethod; virtual;
    // Sort the methods on their name
    procedure SortMethods;
  public
    constructor create(const aServiceName : string);
    destructor destroy; override;
    // Add a method to the list of methods.
    Function AddMethod(const aName : String; aOperation : TAPIOperation; aPath : TPathItem) : TAPIserviceMethod;
    // Does this service need authentication ?
    Property NeedsAuthentication : Boolean read FNeedsAuthentication Write FNeedsAuthentication;
    // Pascal name of the service
    Property ServiceName : string Read FServiceName;
    // Interface name of the service.
    Property ServiceInterfaceName : string Read GetServiceInterfaceName Write FServiceInterfaceName;
    // Parent interface for the service interface
    Property ServiceParentInterface : String Read FServiceParentInterface Write FServiceParentInterface;
    // Service interface UUID
    Property ServiceUUID : string Read GetServiceUUID Write FServiceUUID;
    // Service interface implementation Class Name
    Property ServiceImplementationClassName : String Read GetServiceImplementationClassName Write FServiceImplementationClassName;
    // Indexed access to methods.
    Property Methods[aIndex : Integer]: TAPIServiceMethod Read GetMethod;
    // Number of methods.
    Property MethodCount : Integer Read GetMethodCount;
  end;

  { TAPIData }

  TAPIData = Class(TSchemaData)
  Private
    FInterfaceArrayType: String;
    FServiceNamePrefix: String;
    FServiceNameSuffix: String;
    FServiceParentInterface: String;
    FServices : TFPObjectList;
    FServiceOperationMap : TFPStringHashTable;
    FAPI : TOpenAPI;
    FVoidResultCallbackType: String;
    function AllowOperation(aKeyword: TPathItemOperationKeyword; aOperation: TAPIOperation): boolean;
    function GetAPITypeCount: Integer;
    function GetService(aIndex : Integer): TAPIService;
    function GetServiceCount: Integer;
    function GetTypeData(aIndex : Integer): TAPITypeData;
    function GetVoidResultCallbackType: String;
  Protected
    //
    // Type management
    //
    procedure FinishAutoCreatedType(aName: string; aType: TPascalTypeData; lElementTypeData: TPascalTypeData); override;
    // Called after a new type is created.
    procedure ConfigType(aType: TAPITypeData); virtual;
    // Find requested name type in API types, based on openAPI name.
    function RawToNameType(const aName: string; aNameType: TNameType): string; virtual;
    // Check whether a type needs to be serialized (i.e. is sent to REST service)
    Function NeedsSerialize(aData : TAPITypeData) : Boolean; virtual;
    // Check whether a type needs to be de-serialized (i.e. is received from the REST service)
    Function NeedsDeSerialize(aData : TAPITypeData) : Boolean; virtual;
    // Is the request body application/json or no request body
    function IsRequestBodyApplicationJSON(aOperation: TAPIOperation): Boolean;
    // Is the response content application/json or no response content
    function IsResponseContentApplicationJSON(aOperation: TAPIOperation): boolean;
   //
    // Service/Method management
    //
    // Generate the name of the service, based on URL/Operation. Takes into account the mapping.
    function GenerateServiceName(const aUrl : String; const aPath: TPathItem; aOperation: TAPIOperation): String;virtual;
    // Create a new service definition. Override this if you want to subclass it.
    function CreateService(const aName: String): TAPIService; virtual;
    // Add a service
    function AddService(const aName: String) : TAPIService;
    // Configure a service
    procedure ConfigService(const aService: TAPIService); virtual;
    // Generate the name of the method, based on URL/Operation. Takes into account the mapping.
    function GenerateServiceMethodName(const aUrl : String; const aPath: TPathItem; aOperation: TAPIOperation): String; virtual;
    // Return the request body type. The application/json content type is used.
    function GetMethodRequestBodyType(aMethod: TAPIServiceMethod): string; virtual;
    // Return the method result type
    function GetMethodResultType(aMethod: TAPIServiceMethod; aNameType: TNameType): String; virtual;
    // Return the method result callback name
    function GenerateMethodResultCallBackName(aMethod: TAPIServiceMethod): String; virtual;
    // Configure the service method. Called after it is created.
    procedure ConfigureServiceMethod(aService: TAPIService; aMethod: TAPIServiceMethod); virtual;
    // Add a parameter to a method.
    function AddServiceMethodParam(aService: TAPIservice; aMethod: TAPIServiceMethod; Idx: Integer; aParam: TParameterOrReference   ): TAPIServiceMethodParam; virtual;
    // Check the input of various operations of a OpenAPI path item. Used in determining the need for serialization
    function CheckOperationsInput(aPath: TPathItem; aData: TAPITypeData): Boolean;
    // Check the output of various operations of a OpenAPI path item. Used in determining the need for deserialization
    function CheckOperationsOutput(aPath: TPathItem; aData: TAPITypeData): Boolean;
    // Check input/output for serialization
    procedure CheckInputOutput;
  Public
    // Create. API must be alive while the data is kept alive.
    constructor Create(aAPI : TOpenAPI); reintroduce;
    // Destroy
    destructor Destroy; override;
    // Create default type maps (integer,string etc.)
    Procedure CreateDefaultTypeMaps; virtual;
    // Create default API type maps (#components in openapi)
    Procedure CreateDefaultAPITypeMaps;
    // Create service defs from paths. Call RecordMethodNameMap first)
    Procedure CreateServiceDefs; virtual;
    // Get schema element typename of aRef. For components, return requested name
    function GetRefSchemaTypeName(const aRef: String; aNameType : TNameType): string; virtual;
    // Create a new API type. You can override this to return a descendent class
    function CreatePascalType(aIndex: integer; aPascalType : TPascaltype; const aAPIName, aPascalName: String; aSchema: TJSONSchema): TAPITypeData; override;
    // Is the schema an API component ?
    Function IsAPIComponent(aSchema : TJSONSchema) : Boolean;
    // Is the schema an array of API components ?
    Function IsAPIComponentArray(aSchema : TJSONSchema) : Boolean;
    // Get the specified type name of a schema
    function GetSchemaTypeName(aSchema : TJSONSchema; aNameType : TNameType) : String;
    // Apply the UUIDs to the API types. Call after CreateDefaultAPITypeMaps
    procedure ApplyUUIDMap(aMap: TStrings);
    {
      Store the service/maps for operations. Call before CreateServiceDefs
      an entry is either
      operationID=ServiceName[.MethodName]
      or
      HTTPMethod.Path=ServiceName[.MethodName]
    }
    procedure RecordMethodNameMap(aMap: TStrings);
    // Index of service with given ServiceName. Return -1 if not found.
    function IndexOfService(const aName : String) : Integer;
    // Find service with given ServiceName. Can return Nil
    function FindService(const aName : String) : TAPIService;
    // Find service with given ServiceName. Raise exception if not found
    function GetServiceByName(const aName : String) : TAPIService;
    // Indexed access to services
    Property Services[aIndex :Integer] : TAPIService Read GetService;
    // Number of generated services
    Property ServiceCount : Integer Read GetServiceCount;
    // Return index of named API type (name as in OpenApi). Return -1 if not found.
    function IndexOfAPIType(const aName: String): integer;
    // Find API type by name (name as known in OpenApi). Return nil if not found.
    function FindApiType(const aName: String): TAPITypeData;
    // Find API type by name (name as known in OpenApi). Raise exception if not found.
    function GetAPIType(const aName: String): TAPITypeData;
    // #components Types by name
    Property ApiNamedTypes[aName : String] : TAPITypeData Read GetApiType;
    // #components Types by index
    Property APITypes[aIndex : Integer] : TAPITypeData Read GetTypeData;
    // #components Type count
    Property APITypeCount : Integer Read GetAPITypeCount;
    // The api we generate code for.
    Property API : TOpenAPI Read FAPI;
    // Prefix to use when generating service names (will still have I prepended for interface definition)
    Property ServiceNamePrefix : String Read FServiceNamePrefix Write FServiceNamePrefix;
    // Suffix to use when generating service names (will still have I prepended for interface definition)
    // By default, this is 'Service'
    Property ServiceNameSuffix : String Read FServiceNameSuffix Write FServiceNameSuffix;
    // Parent interface for services. Applied to all services
    Property ServiceParentInterface : String Read FServiceParentInterface Write FServiceParentInterface;
    // Void result type callback name
    Property VoidResultCallbackType : String Read GetVoidResultCallbackType Write FVoidResultCallbackType;
    // Name of generic Interface that implements an array
    Property InterfaceArrayType : String Read FInterfaceArrayType Write FInterfaceArrayType;
  end;

implementation

{$IFDEF FPC_DOTTEDUNITS}
uses System.StrUtils;
{$ELSE}
uses strutils;
{$ENDIF}

function PrettyPrint(S : String) : String;

begin
  Result:=S;
  if Length(Result)>0 then
    Result[1]:=UpCase(Result[1]);
end;

{ TAPITypeData }


function CompareServiceName(Item1, Item2: Pointer): Integer;

var
  lService1 : TAPIService absolute Item1;
  lService2 : TAPIService absolute Item2;

begin
  Result:=CompareText(lService1.ServiceName,lService2.ServiceName);
end;

function CompareMethodName(Item1, Item2: Pointer): Integer;

var
  lMethod1 : TAPIServiceMethod absolute Item1;
  lMethod2 : TAPIServiceMethod absolute Item2;

begin
  Result:=CompareText(lMethod1.MethodName,lMethod2.MethodName);
end;

function CompareParamName(Item1, Item2: Pointer): Integer;

var
  lParam1 : TAPIServiceMethodParam absolute Item1;
  lParam2 : TAPIServiceMethodParam absolute Item2;
begin
  Result:=CompareText(lParam1.Name,lParam2.Name);
end;


{ TAPIServiceMethodParam }

function TAPIServiceMethodParam.Getlocation: TParamLocation;
begin
  if FParameter.In_='query' then
    Result:=plQuery
  else
    Result:=plPath;
end;

function TAPIServiceMethodParam.GetAsStringValue: String;

var
  lType : TSchemaSimpleType;

begin
  lType:=TAPITypeData.ExtractFirstType(FParameter.Schema);
  case lType of
    sstInteger : Result:=Format('IntToStr(%s)',[Name]); // Also handles int64
    sstString :  Result:=Name;
    sstNumber : Result:=Format('FloatToStr(%s,cRestFormatSettings)',[Name]);
    sstBoolean : Result:=Format('cRESTBooleans[%s]',[Name]);
  else
    Result:=Name;
  end;
end;

constructor TAPIServiceMethodParam.create(aArgType: TPropertyType; aOriginalName: String; aName: String; aTypeName: String;
  aParam: TParameter);
begin
  FArgType:=aArgType;
  FOriginalName:=aOriginalName;
  FName:=aName;
  FTypeName:=aTypeName;
  FParameter:=aParam;
end;

{ TAPIService }

function TAPIService.GetMethod(aIndex : Integer): TAPIServiceMethod;
begin
  Result:=TAPIServiceMethod(FMethods[aIndex]);
end;

function TAPIService.GetMethodCount: Integer;
begin
  Result:=FMethods.Count;
end;

function TAPIService.GetServiceImplementationClassName: String;
begin
  Result:=FServiceImplementationClassName;
  if Result='' then
    Result:='T'+ServiceName;
end;

function TAPIService.GetServiceInterfaceName: string;
begin
  Result:=FServiceInterfaceName;
  if Result='' then
    Result:='I'+ServiceName;
end;

function TAPIService.GetServiceUUID: string;
begin
  if FServiceUUID='' then
    FServiceUUID:=TGUID.NewGuid.ToString(False);
  Result:=FServiceUUID;
end;

function TAPIService.CreateMethod(aOperation: TAPIOperation; aPath: TPathItem; const aName: String): TAPIserviceMethod;
begin
  Result:=TAPIserviceMethod.Create(aOperation,aPath,Self,aName);
end;

procedure TAPIService.SortMethods;
begin
  FMethods.Sort(@CompareMethodName);
end;

constructor TAPIService.create(const aServiceName: string);
begin
  FMethods:=TFPObjectList.Create(True);
  FServiceName:=aServiceName;
  FNeedsAuthentication:=True;
end;

destructor TAPIService.destroy;
begin
  FreeAndNil(FMethods);
  inherited destroy;
end;

function TAPIService.AddMethod(const aName: String; aOperation: TAPIOperation; aPath : TPathItem): TAPIserviceMethod;
begin
  Result:=CreateMethod(aOperation,aPath,aName);
  FMethods.Add(Result);
end;

{ TAPIServiceMethod }

function TAPIServiceMethod.GetParam(aIndex : Integer): TAPIServiceMethodParam;
begin
  Result:=TAPIServiceMethodParam(FParams[aIndex]);
end;

function TAPIServiceMethod.GetParamCount: Integer;
begin
  Result:=FParams.Count;
end;

procedure TAPIServiceMethod.SortParams;
begin
   FParams.Sort(@CompareParamName);
end;

constructor TAPIServiceMethod.create(aOperation: TApiOperation;
  aPath: TPathItem; aService: TAPIService; const aMethod: String);
begin
  FOperation:=aOperation;
  FService:=aService;
  FMethodName:=aMethod;
  FPath:=aPath;
  FParams:=TFPObjectList.Create(True);
end;

destructor TAPIServiceMethod.Destroy;
begin
  FreeAndNil(FParams);
  inherited Destroy;
end;

function TAPIServiceMethod.CreateParam(const aType : TPascaltype; const aOriginalName,aName, aTypeName: String; aParam: TParameter): TAPIServiceMethodParam;

begin
  Result:=TAPIServiceMethodParam.Create(aType,aOriginalName,aName,aTypeName,aParam);
end;

function TAPIServiceMethod.AddParam(const aType : TPascalType; const aOriginalName,aName, aTypeName: String; aParam: TParameter): TAPIServiceMethodParam;

begin
  Result:=CreateParam(aType,aOriginalName,aName,aTypeName,aParam);
  FParams.Add(Result);
end;

function TAPIServiceMethod.ParamByNAme(aOriginalName: String): TAPIServiceMethodParam;

var
  Idx : Integer;

begin
  Idx:=ParamCount-1;
  While (Idx>=0) and Not SameText(Param[Idx].OriginalName,aOriginalName) do
    Dec(Idx);
  if Idx=-1 then
    Result:=Nil
  else
    Result:=Param[Idx];
end;

function TAPIServiceMethod.HasPathParam: Boolean;

var
  I : Integer;

begin
  Result:=False;
  For I:=0 to ParamCount-1 do
    if Param[i].Location=plPath then
      Exit(True);
end;

function TAPIServiceMethod.HasQueryParam: Boolean;

var
  I : Integer;

begin
  Result:=False;
  For I:=0 to ParamCount-1 do
    if Param[i].Location=plQuery then
      Exit(True);
end;

function TAPIServiceMethod.HasOptionalParams: Boolean;
var
  I : Integer;

begin
  Result:=False;
  For I:=0 to ParamCount-1 do
    if (Param[i].DefaultValue<>'') then
      Exit(True);
end;

{ TAPIData }

function TAPIData.GetTypeData(aIndex : Integer): TAPITypeData;

begin
  Result:=TAPITypeData(Inherited Types[aIndex]);
end;

function TAPIData.GetVoidResultCallbackType: String;
begin
  Result:=FVoidResultCallbackType;
  if Result='' then
    Result:='TVoidResultCallBack';
end;

function TAPIData.CreatePascalType(aIndex: integer; aPascalType: TPascaltype; const aAPIName, aPascalName: String;
  aSchema: TJSONSchema): TAPITypeData;
begin
  Result:=TAPITypeData.Create(aIndex,aPascalType,aAPIName,aPascalName,aSchema);
end;

function TAPIData.GetAPITypeCount: Integer;

begin
  Result:=TypeCount;
end;

function TAPIData.GetService(aIndex : Integer): TAPIService;

begin
  Result:=TAPIService(FServices[aIndex]);
end;

function TAPIData.GetServiceCount: Integer;

begin
  Result:=FServices.Count;
end;

function TAPIData.IndexOfAPIType(const aName : String): integer;

begin
  Result:=IndexOfSchemaType(aName);
end;

function TAPIData.FindApiType(const aName: String): TAPITypeData;

var
  Idx : Integer;

begin
  Result:=Nil;
  Idx:=IndexOfApiType(aName);
  if Idx<>-1 then
    Result:=APITypes[Idx];
end;

function TAPIData.GetAPIType(const aName : String): TAPITypeData;

begin
  Result:=FindAPIType(aName);
  if Result=Nil then
    Raise EListError.CreateFmt('Unknown type: %s',[aName]);
end;

function TAPIData.CreateService(const aName: String): TAPIService;

begin
  Result:=TAPIService.Create(aName);
end;

procedure TAPIData.ConfigService(const aService : TAPIService);

begin
  aService.ServiceParentInterface:=Self.ServiceParentInterface;
end;

function TAPIData.AddService(const aName: String): TAPIService;

begin
  Result:=CreateService(aName);
  FServices.Add(Result);
end;

constructor TAPIData.Create(aAPI: TOpenAPI);

begin
  Inherited Create;
  FServices:=TFPObjectList.Create(True);
  FServiceOperationMap:=TFPStringHashTable.Create;
  FAPI:=aAPI;
  FServiceNameSuffix:='Service';
  FServiceNamePrefix:='';
end;

destructor TAPIData.Destroy;

begin
  FreeAndNil(FServices);
  FreeAndNil(FServiceOperationMap);
  inherited Destroy;
end;

procedure TAPIData.CreateDefaultTypeMaps;

begin
  DefineStandardPascalTypes;
end;


procedure TAPIData.ConfigType(aType :TAPITypeData);


begin
  aType.InterfaceName:=EscapeKeyWord(InterfaceTypePrefix+aType.SchemaName);
  aType.InterfaceUUID:=TGUID.NewGUID.ToString(False);
end;

procedure TAPIData.ApplyUUIDMap(aMap : TStrings);

var
  I : Integer;
  N,V : String;
  lData : TAPITypeData;
  lService : TAPIService;

begin
  if aMap.Count=0 then exit;
  For I:=0 to aMap.Count-1 do
    begin
    aMap.GetNameValue(I,N,V);
    lData:=FindApiType(N);
    if assigned(lData) then
      lData.InterfaceUUID:=V
    else
      begin
      lService:=FindService(N);
      if assigned(lService) then
        lService.ServiceUUID:=V;
      end;
    end;
end;

procedure TAPIData.RecordMethodNameMap(aMap: TStrings);

var
  I : Integer;
  N,V : String;

begin
  if aMap.Count=0 then exit;
  For I:=0 to aMap.Count-1 do
    begin
    aMap.GetNameValue(I,N,V);
    FServiceOperationMap.Add(N,V);
    end;
end;

function TAPIData.IndexOfService(const aName: String): Integer;

begin
  Result:=FServices.Count-1;
  While (Result>=0) and not SameText(aName,GetService(Result).ServiceName) do
    Dec(Result);
end;

function TAPIData.FindService(const aName: String): TAPIService;

var
  Idx : Integer;

begin
  Result:=nil;
  Idx:=IndexOfService(aName);
  if Idx>=0 then
    Result:=GetService(Idx);
end;

function TAPIData.GetServiceByName(const aName: String): TAPIService;

begin
  Result:=FindService(aName);
  if Result=Nil then
    Raise EGenAPI.CreateFmt('Unknown service: %s',[aName]);
end;

procedure TAPIData.CheckInputOutput;

var
  I: Integer;
  lData : TAPITypeData;
  lSerTypes : TSerializeTypes;

begin
  for I:=0 to TypeCount-1 do
    begin
    lSerTypes:=[];
    lData:=APITypes[i];
    if NeedsSerialize(lData) then
      Include(lSerTypes,stSerialize);
    if NeedsDeserialize(lData) then
      Include(lSerTypes,stDeSerialize);
    lData.SerializeTypes:=lSerTypes;
    DoLog(etInfo,'%s needs serialize: %s, deserialize: %s',[lData.SchemaName,BoolToStr(stSerialize in lSerTypes,True),BoolToStr(stDeSerialize in lSerTypes,True)]);
    end;
end;

procedure TAPIData.CreateDefaultAPITypeMaps;

  Procedure AddProperties(aType : TAPITypeData);

  var
    I : Integer;

  begin
    for I:=0 to aType.Schema.Properties.Count-1 do
      AddTypeProperty(aType,aType.Schema.Properties[i]);
    aType.SortProperties;
  end;

var
  I : Integer;
  lName,lType : String;
  lSchema : TJsonSchema;
  lData : TAPITypeData;

begin
  For I:=0 to FAPI.Components.Schemas.Count-1 Do
    begin
    lName:=FAPI.Components.Schemas.Names[I];
    lSchema:=FAPI.Components.Schemas.Schemas[lName];
    if sstObject in lSchema.Validations.Types then
      begin
      lType:=EscapeKeyWord(ObjectTypePrefix+lName+ObjectTypeSuffix);
      lData:=CreatePascalType(I,ptSchemaStruct,lName,lType,lSchema);
      ConfigType(lData);
      AddType(lName,lData);
      AddToTypeMap(lName,lData);
      end;
    end;
  // We do this here, so all API type references can be resolved
  For I:=0 to APITypeCount-1 do
    AddProperties(APITypes[i]);
  // Finally, sort
  CheckDependencies;
  SortTypes;
  CheckInputOutput;
end;

function TAPIData.GenerateServiceName(const aUrl: String; const aPath: TPathItem;
  aOperation: TAPIOperation): String;

  function CleanIdentifier(S : String) : String;

  begin
    Result:=StringReplace(S,' ','',[rfReplaceAll])
  end;
{
  the maps contain ServiceName.MethodName.
  We use ServiceName if there is an entry in the map.
  if there is no entry in the map and there is 1 tag, we take the name of the tag.
  if there is no tag, we take the first component of the URL path.
}

var
  S,lTag,lFullName : String;
  lStrings : TStringDynArray;

begin
  Result:='';
  if (aOperation.Tags.Count=1) then
    lTag:=ServiceNamePrefix+CleanIdentifier(aOperation.Tags[0])+ServiceNameSuffix
  else
    lTag:='';
  if aOperation.OperationID<>'' then
    lFullName:=FServiceOperationMap.Items[aOperation.OperationID]
  else if LTag<>'' then
    lFullName:=lTag+'.'+aOperation.OperationID
  else
    lFullName:=FServiceOperationMap.Items[aOperation.PathComponent+'.'+aURL];
  if lFullName='' then
    begin
    lStrings:=SplitString(aURL,'/');
    // First non-empty
    For S in lStrings do
      if (Result='') and (S<>'') then
        Result:=S;
    Result:=ServiceNamePrefix+PrettyPrint(Result)+ServiceNameSuffix;
    end
  else
    begin
    lStrings:=SplitString(lFullName,'.');
    Result:=LStrings[0];
    end;
  if (aOperation.OperationID<>'') and (lFullName='') then
    begin
    S:=aOperation.OperationID;
    DoLog(etWarning,'No mapping for %s: (Tag= "%s"), Generated: %s=%s.%s',[S,lTag,S,Result,S]);
    end;
end;

function TAPIData.GenerateServiceMethodName(const aUrl: String;
  const aPath: TPathItem; aOperation: TAPIOperation): String;

(*
  the maps contain ServiceName[.MethodName]
  1. if there is a method name in either map: we use that.
  2. if there is no method name in either map:
     a. if there is an operation ID we use it as the method name.
     b. if there is no operation ID, we use the operation HTTP method together with the url except the first path component.
        Parameters are reduced to their names.
        get /users/contacts/{Id} -> servicename "users" method "get_contacts_Id"
*)

var
  S,lFullName : String;
  lStrings : TStringDynArray;
  I,J : Integer;

begin
  Result:='';
  if aOperation.OperationID<>'' then
    lFullName:=FServiceOperationMap.Items[aOperation.OperationID]
  else
    lFullName:=FServiceOperationMap.Items[aOperation.PathComponent+'.'+aURL];
  if lFullName='' then
    begin
    Result:=aOperation.OperationID;
    if Result='' then
      begin
      lStrings:=SplitString(aURL,'/');
      Result:=aOperation.PathComponent;
      for I:=1 to Length(lStrings)-1 do
        begin
        S:=lStrings[i];
        S:=StringReplace(S,'{','',[rfReplaceAll]);
        S:=StringReplace(S,'}','',[rfReplaceAll]);
        For J:=1 to Length(S)-1 do
          if not (Upcase(S[J]) in ['A'..'Z','0'..'9','_']) then
        Result:=Result+'_'+S;
        end;
      end;
    end
  else
    begin
    lStrings:=SplitString(lFullName,'.');
    Result:=LStrings[1];
    end;
  Result:=PrettyPrint(Result);
end;

function TAPIData.AddServiceMethodParam(aService: TAPIservice; aMethod : TAPIServiceMethod; Idx : Integer; aParam : TParameterOrReference) : TAPIServiceMethodParam;

var
  lOriginalName,lName,lTypeName : string;
  lTypeData : TPascaltypeData;
  lType : TPascalType;

begin
  if aParam.HasReference then
    begin
    lTypeName:=GetRefSchemaTypeName(aParam.Reference.Ref,ntPascal);
    lName:='';
    lOriginalName:='';
    lType:=ptSchemaStruct;
    end
  else
    begin
    lTypeData:=GetSchemaTypeData(Nil,aParam.Schema,False);
    lTypeName:=lTypeData.GetTypeName(ntPascal);
    lType:=lTypeData.Pascaltype;
    lOriginalName:=aParam.Name;
    lName:='a'+PrettyPrint(lOriginalName);
    end;
  if lName='' then
    lName:=Format('aParam%d',[Idx]);

  Result:=aMethod.AddParam(lType,lOriginalName,lName,lTypeName,aParam);
  if aParam.Schema.MetaData.HasKeywordData(jskDefault) then
    begin
    Result.DefaultValue:=aParam.Schema.MetaData.DefaultValue.AsString;
    if lType=ptString then
      Result.DefaultValue:=''''+StringReplace(Result.DefaultValue,'''','''''',[rfReplaceAll])+'''';
    end;
end;

function TAPIData.IsResponseContentApplicationJSON(aOperation : TAPIOperation) : boolean;

var
  lResponse : TResponse;
  lMedia : TMediaType;

begin
  if aOperation.Responses.Count=0 then
    Result:=True
  else
    begin
    lResponse:=aOperation.Responses.ResponseByindex[0];
    lMedia:=lResponse.Content.MediaTypes['application/json'];
    Result:=lMedia<>nil;
    end;
end;

function TAPIData.GenerateMethodResultCallBackName(aMethod : TAPIServiceMethod) : String;

var
  lResponse: TResponse;
  lMedia : TMediaType;

begin
  if AMethod.Operation.Responses.Count=0 then
    Result:=VoidResultCallbackType
  else
    begin
    lResponse:=AMethod.Operation.Responses.ResponseByindex[0];
    lMedia:=lResponse.Content.MediaTypes['application/json'];
    if (lMedia.Schema.Ref<>'') then
      Result:=Format('%sResultCallBack',[GetRefSchemaTypeName(lMedia.Schema.Ref,ntPascal)])
    else if (lMedia.Schema.Validations.Types=[]) then
      Result:=VoidResultCallbackType
    else
      Result:=GetSchemaTypeName(lMedia.Schema,ntPascal);
    end;
end;

function TAPIData.GetMethodResultType(aMethod : TAPIServiceMethod; aNameType : TNameType) : String;

var
  lResponse: TResponse;
  lMedia : TMediaType;

begin
  Result:='Boolean';
  if AMethod.Operation.Responses.Count>0 then
    begin
    lResponse:=AMethod.Operation.Responses.ResponseByindex[0];
    lMedia:=lResponse.Content.MediaTypes['application/json'];
    if (lMedia.Schema.Ref<>'') then
      Result:=GetRefSchemaTypeName(lMedia.Schema.Ref,aNameType)
    else if (lMedia.Schema.Validations.Types<>[]) then
      Result:=GetSchemaTypeName(lMedia.Schema,aNameType)
    end;
end;

function TAPIData.IsRequestBodyApplicationJSON(aOperation : TAPIOperation) : Boolean;

var
  lMedia : TMediaType;
begin
  Result:=False;
  if Not aOperation.HasKeyWord(okRequestBody) then
    exit(True);
  if aOperation.RequestBody.HasReference then
    // We have a definition
    Result:=GetRefSchemaTypeName(aOperation.RequestBody.Reference.Ref,ntPascal)<>''
  else
    begin
    lMedia:=aOperation.RequestBody.Content['application/json'];
    Result:=lMedia<>Nil;
    end;
end;

function TAPIData.GetMethodRequestBodyType(aMethod : TAPIServiceMethod) : string;

var
  lMedia : TMediaType;

begin
  Result:='';
  if Not aMethod.Operation.HasKeyWord(okRequestBody) then
    exit;
  if aMethod.Operation.RequestBody.HasReference then
    Result:=GetRefSchemaTypeName(aMethod.Operation.RequestBody.Reference.Ref,ntInterface)
  else
    begin
    lMedia:=aMethod.Operation.RequestBody.Content['application/json'];
    if (lMedia.Schema.Ref<>'') then
      Result:=GetRefSchemaTypeName(lMedia.Schema.Ref,ntInterface)
    else if (lMedia.Schema.Validations.Types<>[]) then
      Result:=GetSchemaTypeName(lMedia.Schema,ntInterface);
    end;
end;



procedure TAPIData.ConfigureServiceMethod(aService : TAPIService; aMethod : TAPIServiceMethod);

begin
  aMethod.ResultCallBackType:=GenerateMethodResultCallBackName(aMethod);
  aMethod.ResultType:=GetMethodResultType(aMethod,ntInterface);
  aMethod.ResultClassType:=GetMethodResultType(aMethod,ntImplementation);
  aMethod.ResultDtoType:=GetMethodResultType(aMethod,ntPascal);
  aMethod.RequestBodyType:=GetMethodRequestBodyType(aMethod);
end;


function TAPIData.AllowOperation(aKeyword: TPathItemOperationKeyword; aOperation: TAPIOperation): boolean;

begin
  Result:=True;
  Result:=IsResponseContentApplicationJSON(aOperation);
  if (aKeyword in [pkPost,pkPut,pkPatch]) then
    Result:=IsRequestBodyApplicationJSON(aOperation);
end;

procedure TAPIData.CreateServiceDefs;

var
  I,J : Integer;
  lPath: TPathItem;
  lURL : String;
  lOperation : TAPIOperation;
  lKeyword : TPathItemOperationKeyword;
  lServiceName,lMethodName : String;
  lService : TAPIService;
  lMethod : TAPIServiceMethod;
  lMap : String;

begin
  for I:=0 to FAPI.Paths.Count-1 do
    begin
    lPath:=FAPI.Paths.PathByIndex[I];
    lURL:=FAPI.Paths.Names[I];
    for lKeyword in TPathItemOperationKeyword do
      begin
      lOperation:=lPath.GetOperation(lKeyword);
      if assigned(lOperation) and AllowOperation(lKeyword,lOperation) then
        begin
        lServiceName:=GenerateServiceName(lUrl,lPath,lOperation);
        lService:=FindService(lServiceName);
        if lService=Nil then
          begin
          lService:=AddService(lServiceName);
          ConfigService(lService);
          end;
        lMethodName:=GenerateServiceMethodName(lUrl,lPath,lOperation);
        lMethod:=lService.AddMethod(lMethodName,lOperation,lPath);
        ConfigureServiceMethod(lService,lMethod);
        if lOperation.HasKeyWord(okParameters) then
          for J:=0 to lOperation.Parameters.Count-1 do
            AddServiceMethodParam(lService,lMethod,j,lOperation.Parameters[j]);
        if lOperation.OperationId='' then
          lMap:=lOperation.PathComponent+'.'+lPath.PathComponent
        else
          lMap:=lOperation.OperationID;
        doLog(etInfo,'Map %s on %s.%s',[lMap,lService.ServiceName,lMethod.MethodName]);
        end;
      end;
    end;
  FServices.Sort(@CompareServiceName);
  For I:=0 to ServiceCount-1 do
    begin
    Services[i].SortMethods;
    For J:=0 to Services[i].MethodCount-1 do
      Services[i].Methods[J].SortParams;
    end;
end;


function TAPIData.IsAPIComponent(aSchema: TJSONSchema): Boolean;
begin
  Result:=(aSchema.Ref<>'') and (GetRefSchemaTypeName(aSchema.Ref,ntSchema)<>'');
end;

function TAPIData.IsAPIComponentArray(aSchema: TJSONSchema): Boolean;
begin
  Result:=GetSchemaType(aSchema)=sstArray;
  if Result then
    Result:=(aSchema.Items.Count>0) and IsAPIComponent(aSchema.Items[0]);
end;

function TAPIData.GetRefSchemaTypeName(const aRef: String; aNameType: TNameType): string;

const
  ComponentsRef = '#/components/schemas/';

var
  lLen : Integer;
  lName : string;

begin
  if Pos(ComponentsRef,aRef)=1 then
    begin
    lLen:=Length(ComponentsRef);
    lName:=Copy(aRef,lLen+1,Length(aRef)-lLen);
    if aNameType=ntSchema then
      Result:=lName
    else
      Result:=RawToNameType(lName,aNameType);
    end
  else
    Result:='';
end;

function TAPIData.CheckOperationsInput(aPath : TPathItem; aData: TAPITypeData): Boolean;

  function CheckOperation(aOperation : TAPIOperation)  : Boolean;

  var
    lRef,lName : String;
    lMediaType : TMediaType;
    lInputType : TAPITypeData;

  begin
    Result:=False;
    if aOperation=Nil then
      exit;
    if not aOperation.HasKeyWord(okRequestBody) then
      exit;
    if aOperation.RequestBody.HasReference then
      lRef:=aOperation.RequestBody.Reference.ref
    else
      begin
      if not aOperation.RequestBody.HasKeyWord(rbkContent) then
        exit;
      lMediaType:=aOperation.RequestBody.Content.MediaTypes['application/json'];
      if assigned(lMediaType) and assigned(lMediaType.Schema) then
        lRef:=lMediaType.Schema.Ref
      end;
    if lRef<>'' then
      begin
      lRef:=GetRefSchemaTypeName(lRef,ntSchema);
      lName:=aData.SchemaName;
      if lRef=lName then
        Exit(True);
      lInputType:=GetAPIType(lRef);
      if Assigned(lInputType) and (lInputType.DependsOn(aData,True)<>dtNone) then
        Exit(True);
      end;
  end;

var
  aKeyword : TPathItemOperationKeyword;

begin
  Result:=False;
  For aKeyword in TPathItemOperationKeyword do
    if CheckOperation(aPath.GetOperation(aKeyword)) then
      Exit(True);
end;

function TAPIData.CheckOperationsOutput(aPath : TPathItem; aData: TAPITypeData): Boolean;

  function CheckResponse(aResponse : TResponse) : Boolean;

  var
    lMediaType : TMediaType;
    lName,lRef : String;
    lInputType : TAPITypeData;

  begin
    Result:=False;
    lMediaType:=aResponse.Content.MediaTypes['application/json'];
    if Not (assigned(lMediaType) and assigned(lMediaType.Schema)) then
      exit;
    lRef:=lMediaType.Schema.Ref;
    if lRef='' then
      exit;
    lRef:=GetRefSchemaTypeName(lRef,ntSchema);
    lName:=aData.SchemaName;
    if lRef=lName then
      Exit(True);
    lInputType:=GetAPIType(lRef);
    if Assigned(lInputType) and (lInputType.DependsOn(aData,True)<>dtNone) then
      Exit(True);
  end;

  function CheckOperation(aOperation : TAPIOperation)  : Boolean;

  var
    I : Integer;

  begin
    Result:=False;
    if not Assigned(aOperation) then
      exit;
    if not aOperation.HasKeyWord(okResponses) then
      exit;
    For I:=0 to aOperation.Responses.Count-1 do
      If CheckResponse(aOperation.Responses.ResponseByIndex[I]) then
        Exit(True);
  end;

var
  aKeyword : TPathItemOperationKeyword;

begin
  Result:=False;
  For aKeyword in TPathItemOperationKeyword do
    if CheckOperation(aPath.GetOperation(aKeyword)) then
      Exit(True);
end;


function TAPIData.NeedsSerialize(aData: TAPITypeData): Boolean;

var
  lRef,lName : String;
  Itm : TPathItem;
  lParam: TParameterOrReference;
  lParamType : TAPITypeData;
  I,J : Integer;

begin
  Result:=False;
  lName:=aData.SchemaName;
  For I:=0 to FAPI.Paths.Count-1 do
    begin
    Itm:=FAPI.Paths.PathByIndex[I];
    for J:=0 to Itm.Parameters.Count-1 do
      begin
      lParam:=itm.Parameters[j];
      if (lParam.HasReference) then
        lRef:=lParam.Reference.ref
      else if Assigned(lParam.Schema) then
        lRef:=lParam.Schema.Ref;
      if lRef<>'' then
        begin
        lRef:=GetRefSchemaTypeName(lRef,ntSchema);
        if lRef=lName then
          Exit(True);
        lParamType:=GetAPIType(lRef);
        if Assigned(lParamType) and (lParamType.DependsOn(aData,True)<>dtNone) then
          Exit(True);
        end;
      end;
    If CheckOperationsInput(Itm,aData) then
      exit(True);
    end;
end;

function TAPIData.NeedsDeSerialize(aData: TAPITypeData): Boolean;
var
  Itm : TPathItem;
  I : Integer;

begin
  Result:=False;
  For I:=0 to FAPI.Paths.Count-1 do
    begin
    Itm:=FAPI.Paths.PathByIndex[I];
    if CheckOperationsOutput(Itm,aData) then
      Exit(True);
    end;
end;

function TAPIData.RawToNameType(const aName : string; aNameType: TNameType) : string;

var
  lType : TAPITypeData;

begin
  lType:=FindApiType(aName);
  if Assigned(lType) then
    Result:=lType.GetTypeName(aNameType)
  else
    Result:=aName;
end;


procedure TAPIData.FinishAutoCreatedType(aName: string; aType: TPascalTypeData; lElementTypeData: TPascalTypeData);

begin
  if aType.Pascaltype=ptArray then
    begin
    aType.InterfaceName:=Format('%s<%s>',[InterfaceArrayType,lElementTypeData.InterfaceName]);
    end;
  Inherited;
end;

function TAPIData.GetSchemaTypeName(aSchema: TJSONSchema; aNameType: TNameType): String;

var
{
  lTmp,elType : String;
  lType : TPascalType;
  }
  lData : TPascalTypeData;

begin
  lData:=GetSchemaTypeData(Nil,aSchema,False);
  if assigned(lData) then
    Result:=lData.GetTypeName(aNameType)
  else
    Raise Exception.CreateFmt('No name for schema %s',[aSchema.Name]);
(*
     lType:=SchemaTypeToPascalType(aSchema,Result);

     if lType in [ptInteger,ptInt64,ptBoolean,ptFloat32,ptFloat64,ptString] then
       begin
       lTmp:=Self.TypeMap[Result];
       if lTmp<>'' then
         Result:=lTmp;
       end
     else if lType=ptArray then
       begin
       if aNameType=ntInterface then
         begin
         ElType:=GetSchemaTypeName(aSchema.Items[0],aNametype);
         Result:=Format(InterfaceArrayType,[elType])
         end
       else
         if DelphiTypes then
           Result:='TArray<'+GetSchemaTypeName(aSchema.Items[0],aNametype)+'>'
         else
           Result:='Array of '+GetSchemaTypeName(aSchema.Items[0],aNametype);
       end;
     end;
*)
end;


function TAPITypeData.CreateProperty(const aAPIName, aPascalName: string): TPascalPropertyData;
begin
  Result:=TAPIProperty.Create(aAPIName,aPascalName);
end;

function TAPITypeData.AddProperty(const aApiName, aPascalName: String): TAPIProperty;
begin
  Result:=(Inherited AddProperty(aApiName,aPascalName)) as TAPIProperty;
end;

end.
