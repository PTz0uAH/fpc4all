{ Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 }

{
 * @package Apache connection library
 }

{#include "apr_hooks.h"
#include "apr_network_io.h"
#include "apr_buckets.h"}

{
 * @file  http_connection.h
 * @brief Apache connection library
 }

//#ifdef CORE_PRIVATE
{
 * This is the protocol module driver.  This calls all of the
 * pre-connection and connection hooks for all protocol modules.
 * @param c The connection on which the request is read
 * @param csd The mechanism on which this connection is to be read.  
 *            Most times this will be a socket, but it is up to the module
 *            that accepts the request to determine the exact type.
 * @deffunc void ap_process_connection(conn_rec *c, void *csd)
 }
procedure ap_process_connection(c: Pconn_rec; csd: Pointer);
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_process_connection' + LibSuff8;

{
 * Flushes all remain data in the client send buffer
 * @param c The connection to flush
 }
procedure ap_flush_conn(c: Pconn_rec);
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_flush_conn' + LibSuff4;

{
 * This function is responsible for the following cases:
 * <pre>
 * we now proceed to read from the client until we get EOF, or until
 * MAX_SECS_TO_LINGER has passed.  the reasons for doing this are
 * documented in a draft:
 *
 * http://www.ics.uci.edu/pub/ietf/http/draft-ietf-http-connection-00.txt
 *
 * in a nutshell -- if we don't make this effort we risk causing
 * TCP RST packets to be sent which can tear down a connection before
 * all the response data has been sent to the client.
 * </pre>
 * @param c The connection we are closing
 }
procedure ap_lingering_close(c: Pconn_rec);
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_lingering_close' + LibSuff4;

//#endif COREPRIVATE

  { Hooks }
{
 * create_connection is a RUN_FIRST hook which allows modules to create 
 * connections. In general, you should not install filters with the 
 * create_connection hook. If you require vhost configuration information 
 * to make filter installation decisions, you must use the pre_connection
 * or install_network_transport hook. This hook should close the connection
 * if it encounters a fatal error condition.
 *
 * @param p The pool from which to allocate the connection record
 * @param csd The socket that has been accepted
 * @param conn_id A unique identifier for this connection.  The ID only
 *                needs to be unique at that time, not forever.
 * @param sbh A handle to scoreboard information for this connection.
 * @return An allocated connection record or NULL.
 }
type
  ap_HOOK_create_connection_t = function (p: Papr_pool_t; server: Pserver_rec;
   csd: Papr_socket_t; conn_id: cLong; sbh: Pointer;
   alloc: Papr_bucket_alloc_t): Pconn_rec; cdecl;

procedure ap_hook_create_connection(pf: ap_HOOK_create_connection_t; const aszPre: PPAnsiChar;
 const aszSucc: PPAnsiChar; nOrder: Integer);
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_hook_create_connection' + LibSuff16;

{
 * This hook gives protocol modules an opportunity to set everything up
 * before calling the protocol handler.  All pre-connection hooks are
 * run until one returns something other than ok or decline
 * @param c The connection on which the request has been received.
 * @param csd The mechanism on which this connection is to be read.  
 *            Most times this will be a socket, but it is up to the module
 *            that accepts the request to determine the exact type.
 * @return OK or DECLINED
 * @deffunc int ap_run_pre_connection(conn_rec *c, void *csd)
 }
type
  ap_HOOK_pre_connection_t = function (c: Pconn_rec; csd: Pointer): Integer; cdecl;

procedure ap_hook_pre_connection(pf: ap_HOOK_pre_connection_t; const aszPre: PPAnsiChar;
 const aszSucc: PPAnsiChar; nOrder: Integer);
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_hook_pre_connection' + LibSuff16;

{
 * This hook implements different protocols.  After a connection has been
 * established, the protocol module must read and serve the request.  This
 * function does that for each protocol module.  The first protocol module
 * to handle the request is the last module run.
 * @param c The connection on which the request has been received.
 * @return OK or DECLINED
 * @deffunc int ap_run_process_connection(conn_rec *c)
 }
type
  ap_HOOK_process_connection_t = function (c: Pconn_rec): Integer; cdecl;

procedure ap_hook_process_connection(pf: ap_HOOK_process_connection_t; const aszPre: PPAnsiChar;
 const aszSucc: PPAnsiChar; nOrder: Integer);
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_hook_process_connection' + LibSuff16;

{ End Of Connection (EOC) bucket }

//AP_DECLARE_DATA extern const apr_bucket_type_t ap_bucket_type_eoc;

{
 * Determine if a bucket is an End Of Connection (EOC) bucket
 * @param e The bucket to inspect
 * @return true or false
 }
//#define AP_BUCKET_IS_EOC(e)         (e->type == &ap_bucket_type_eoc)

{
 * Make the bucket passed in an End Of Connection (EOC) bucket
 * @param b The bucket to make into an EOC bucket
 * @return The new bucket, or NULL if allocation failed
 * @deffunc apr_bucket *ap_bucket_eoc_make(apr_bucket *b)
 }
function ap_bucket_eoc_make(b: Papr_bucket): Papr_bucket;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_bucket_eoc_make' + LibSuff4;

{
 * Create a bucket referring to an End Of Connection (EOC). This indicates
 * that the connection will be closed.
 * @param list The freelist from which this bucket should be allocated
 * @return The new bucket, or NULL if allocation failed
 * @deffunc apr_bucket *ap_bucket_eoc_create(apr_bucket_alloc_t *list)
 }
function ap_bucket_eoc_create(list: Papr_bucket_alloc_t): Papr_bucket;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_bucket_eoc_create' + LibSuff4;

