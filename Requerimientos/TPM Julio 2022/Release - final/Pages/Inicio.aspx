<%@ Page Title="" Language="C#" MasterPageFile="~/includes/magnajs.Master" AutoEventWireup="true" CodeBehind="Inicio.aspx.cs" Inherits="magnajs.Pages.Inicio" %>


<asp:Content ID="Content1" ContentPlaceHolderID="main" runat="server">
    <div class="view dashboard" ng-controller="inicioController as vm" style="margin-top: 0px;">
        <h1>{{vm.titulo}}</h1>
        <div class="row" style="margin-top: 0px;">
            <div class="col-12 col-lg-8 col-md-6"></div>
            <div class="col-12 col-lg-4 col-md-6">
                <div class="summary-boxes" layout="row" layout-align="space-between center" style="margin-top: 0px; margin-bottom: 8px;">
                    <div class="summary-box summary-pending" ng-click="vm.consultar(vm.LineaId, vm.DeptoId, 'ROJO')">
                        <div class="summary-box-main">
                            <div class="summary-value">{{vm.rojo}}</div>
                        </div>
                        <div class="summary-box-footer"><%= this.GetMessage("Rojo") %></div>
                    </div>
                    <div class="summary-box summary-total" ng-click="vm.consultar($scope.LineaId, $scope.DeptoId, 'AMARILLO')">
                        <div class="summary-box-main">
                            <div class="summary-value">{{vm.amarillo}}</div>
                        </div>
                        <div class="summary-box-footer"><%= this.GetMessage("Amarillo") %></div>
                    </div>
                    <div class="summary-box summary-amount" ng-click="vm.consultar($scope.LineaId, $scope.DeptoId, 'VERDE')">
                        <div class="summary-box-main">
                            <div class="summary-value">{{vm.verde}}</div>
                        </div>
                        <div class="summary-box-footer"><%= this.GetMessage("Verde") %></div>
                    </div>
                </div>
            </div>
        </div>
        <div id="Home" class="mail-box padding-10 wrapper border-bottom" style="margin-top: 0px;">
            <br />
            <div class="content-top clearfix"> 
                <div class="row">
                    <div class="col-sm-5">
                         <button type="button" class="btn btn-link" ng-click="openModalHistorico(null, true)" ng-show="vm.esAprobador == 1">
                                    <i class="fa fa-list" title="Pendientes de autorización o rechazo..."></i>
                             <span>Pendientes de revisión</span>
                         </button>
                    </div> 
                    <div class="col-sm-2">
                        <select class="form-control form-control-select" ng-model="vm.EstatusId" ng-change="vm.consultar(vm.LineaId, vm.DeptoId, '', vm.EstatusId)"
                            ng-options="item.EstatusId as item.Descripcion for item in vm.estatus" ng-hide="true">
                            <option value="" class="text-center">[ TODOS LOS ESTATUS ]</option>
                        </select>
                    </div> 
                    <div class="col-sm-3">
                        <select class="form-control form-control-select" ng-model="vm.DeptoId" ng-change="llenarLinea(vm.DeptoId)"
                            ng-options="item.DeptoId as item.NombreDepto for item in vm.depto">
                            <option value="" class="text-center">[ TODOS LOS DEPARTAMENTOS ]</option>
                        </select>
                    </div>
                    <div class="col-sm-2">
                        <select class="form-control form-control-select" ng-model="vm.LineaId" ng-change="vm.consultar(vm.LineaId, vm.DeptoId, '', vm.EstatusId)"
                            ng-options="item.WorkCenterId as item.WorkCenter for item in vm.linea">
                            <option value="" class="text-center">[ TODAS LAS LINEAS ]</option>
                        </select>
                    </div> 
                </div>
            </div>
            <br />
            <div ui-table="vm.principal" st-fixed style="width: 100%">
                <table class="jsgrid-table" style="width: 880px; min-width: 880px"
                    st-table="vm.principal" st-safe-src="vm.principal_">
                    <thead>
                        <tr> 
                            <th ui-field width="5" ></th>
                            <th id="primero" ui-field width="90" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-WorkCenter") %></th>
                            
                            <th ui-field width="200" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-Descripcion") %></th>
                            <th ui-field width="90" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-Equipo") %></th>
                            <th ui-field width="70" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-Frecuencia") %></th>
                            <th ui-field width="80" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-PiezasProducidas") %></th>
                            <th ui-field width="80" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-Porcentaje") %></th>
                            
                            <th ui-field width="5" ></th>
                            <th ui-field width="80" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-UltimaEjecucion") %></th>
                            <th ui-field width="100" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-EstatusFlujo") %></th>
                            <th ui-field width="50" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-FechaFlujo") %></th>
                            <th id="ultimo" ui-field width="40"></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr ng-repeat="item in vm.principal"> 
                            <td class="{{item.summary_color}}" ></td>
                            <td st-ratio="90" style="font-weight: bold;" class="text-center">{{item.WorkCenter}}</td>
                            <td st-ratio="200" class="text-center">{{item.DescripTechnical}}</td>
                            <td st-ratio="90" class="text-center">
                                  <button type="button" class="btn btn-link" ng-click="openModalHistorico(item, false)" >
                                       {{item.CodEquipo}}    <i class="fa fa-history" title="Ver histórico..."></i>
                                </button>
                            </td>
                            <td st-ratio="70" class="text-center">{{item.Frecuencia}}</td>
                            <td st-ratio="80" class="text-center">{{item.PzsProduc}}</td>
                            <td st-ratio="80" class="text-center">{{item.Porcentaje}}</td>
                            <td class="{{item.summary_color}}" ></td>
                            <td st-ratio="80" class="text-center">{{item.UltimaEjec}}</td>
                            <td st-ratio="100" class="text-center">{{item.Estatus}}</td>
                            <td st-ratio="50" class="text-center">{{item.FechaFlujo}}</td>
                            <td st-ratio="30" class="text-center">
                                <button type="button" class="btn btn-link" ng-click="openModalNotas(item)" ng-show="item.Critico == 1">
                                    <i class="fa fa-eye" title="Capturar checklist..."></i>
                                </button>
                            </td>
                        </tr>
                        <tr ng-if="vm.principal.length == 0" class="nodata-row">
                            <td colspan="8" class="text-center">
                                <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <br />
        <ui-modal modal="modalNotas">
            <div class="modal-dialog modal-lg" form="modalForm" style="width: 1200px;">
                <div class="modal-content" ng-form="FormaActualizacion">
                    <div class="modal-header" style="background-color: #2dacd1">
                        <h4 style="color: black; font-weight: 600; opacity: .9;" class="al-title"><%= this.GetMessage("TituloModal") %></h4>
                    </div>
                    <div class="modal-body" ng-class="{'submitted': submitted}" style="overflow: hidden">
                        <div class="view dashboard" style="margin-top: 0px; margin-bottom: 2px;">
                            <h1><%= this.GetMessage("TituloGeneral") %></h1>
                            <div class="row mb">
                                <div class="col-sm-1">
                                    <span style="color: #0069af"><%= this.GetMessage("IdChkEquipo") %></span>
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" ng-model="chklsxEq.IdChkEquipo" class="control-label" disabled />
                                </div>  
                                <div class="col-sm-1">
                                    <span style="color: #0069af"><%= this.GetMessage("Departamento") %></span>
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" ng-model="chklsxEq.CodDepartamento" class="control-label" disabled />
                                </div>     
                                 <div class="col-sm-1">
                                    <span style="color: #0069af"><%= this.GetMessage("Checklist") %></span>
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" ng-model="chklsxEq.CodChkList" class="control-label" disabled />
                                </div>   
                                <div class="col-sm-1">
                                    <span style="color: #0069af"><%= this.GetMessage("gvGeneral-WorkCenter") %></span>
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" ng-model="chklsxEq.WorkCenter" class="control-label" disabled />
                                    <input type="text" ng-model="chklsxEq.IdChkEquipo" class="control-label" ng-hide="true" /> 
                                     <input type="text" ng-model="chklsxEq.CodEquipo" class="control-label" ng-hide="true" />
                                </div>  
                            </div>
                            <div class="row mb">
                                <div class="col-sm-1">
                                    <span style="color: #0069af"><%= this.GetMessage("Nombre") %></span>
                                </div>
                                <div class="col-sm-7">
                                    <input type="text" ng-model="chklsxEq.ChkEquipo" class="control-label" style="width:540px" disabled />
                                </div>            
                                <div class="col-sm-1"></div>
                                <div class="col-sm-1">
                                    <span style="color: #0069af"><%= this.GetMessage("IdChecklist") %></span>
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" ng-model="chklsxEq.IdCheckList" class="control-label" disabled />
                                </div> 
                            </div>
                            <div class="row mb">
                                <div class="col-sm-1">
                                    <span style="color: #0069af"><%= this.GetMessage("Clasificacion") %></span>
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" ng-model="chklsxEq.CodClasif" class="control-label" disabled />
                                </div>                         
                                <div class="col-sm-1">
                                    <span style="color: #0069af"><%= this.GetMessage("Frecuencia") %></span>
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" ng-model="chklsxEq.Frecuencia" class="control-label" disabled />
                                </div>      
                                 <div class="col-sm-2">
                                    <span style="color: #0069af" class="text-left"><%= this.GetMessage("EstatusAprobacion") %></span>
                                </div>  
                                <div class="col-sm-3">
                                    <input type="text" ng-model="chklsxEq.Estatus" class="control-label" disabled />
                                </div>           
                            </div>
                            <div class="row mb">
                                <div class="col-sm-1">
                                    <span style="color: #0069af"><%= this.GetMessage("Periodo") %></span>
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" ng-model="chklsxEq.DesripFrencu" class="control-label" disabled />
                                </div>                         
                                <div class="col-sm-1">
                                    <span style="color: #0069af"><%= this.GetMessage("Estatus") %></span>
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" ng-model="chklsxEq.Activo" class="control-label" disabled />
                                </div>       
                                <div class="col-sm-2">
                                    <span style="color: #0069af"><%= this.GetMessage("FechaAprobacion") %></span>
                                </div>  
                                <div class="col-sm-3">
                                    <input type="text" ng-model="chklsxEq.FechaFlujo" class="control-label" disabled />
                                </div>         
                            </div>
                        </div>
                        <div class="row mb" style="margin-top: 0px;">
                            <div class="col-sm-12">
                                <div id="Home" class="mail-box padding-10 wrapper border-bottom" style="margin-top: 0px;max-height:320px;">
                                    <br />
                                    <div ui-table="vm.tipoApoyoEvidencia" st-fixed style="width: 100%; max-height:250px;overflow-y: scroll;">
                                        <table class="jsgrid-table" style="width: 1130px; min-width: 1130px;"
                                            st-table="vm.tipoApoyoEvidencia" st-safe-src="vm.tipoApoyoEvidencia_">
                                            <thead>
                                                <tr> 
                                                    <th ui-field width="50" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-Orden") %></th>
                                                    <th ui-field width="100" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-Sistema") %></th>
                                                    <th ui-field width="150" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-Componente") %></th>
                                                    <th ui-field width="500" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-Actividad") %></th>
                                                    <th ui-field width="80" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-EquipoParado") %></th>
                                                    <th ui-field width="50" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-UoM") %></th>
                                                    <th ui-field width="150" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-Resultado") %></th>
                                                    <th id="ultimo" ui-field width="500" class="titulo3 text-right" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-Comentarios") %></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr ng-repeat="item in vm.tipoApoyoEvidencia"> 
                                                    <td st-ratio="50" class="text-center">{{item.Orden}}</td>
                                                    <td st-ratio="100" class="text-center">{{item.DescripSistema}}</td>
                                                    <td st-ratio="150" class="text-center">{{item.DescripCompo}}</td>
                                                    <td st-ratio="500" class="text-left">{{item.DescripcionAct}}</td>
                                                    <td st-ratio="80" class="text-center">{{item.EqParado}}</td>
                                                    <td st-ratio="50" class="text-center">{{item.CodUom}}</td>
                                                    <td st-ratio="50" class="text-center" ng-if="item.TipoOperacion == 'V'" >
                                                        <label class="radio-inline">
                                                            <input type="radio" ng-model="item.ResultVisual" value="1" required ng-disabled="(chklsxEq.EstatusId == 1 || chklsxEq.EstatusId == 2 || chklsxEq.EstatusId == 3) || vm.esAprobador == 1">
                                                            <span class="label-color">Ok</span>
                                                        </label> 
                                                        <label class="radio-inline">
                                                            <input type="radio" ng-model="item.ResultVisual" value="0" required ng-disabled="(chklsxEq.EstatusId == 1 || chklsxEq.EstatusId == 2 || chklsxEq.EstatusId == 3) || vm.esAprobador == 1">
                                                            <span class="label-color">No OK</span>
                                                        </label>
                                                    </td> 
                                                    <td st-ratio="50" class="text-center" ng-if="item.TipoOperacion != 'V'">
                                                         <input type="text" ng-model="item.ResultMedible" class="control-label" required />
                                                    </td>
                                                    <td st-ratio="500" class="text-center" >
                                                         <input type="text" ng-model="item.Comentarios" maxlength="259" style="width:540px" class="control-label" required  ng-disabled="(chklsxEq.EstatusId == 1 || chklsxEq.EstatusId == 2 || chklsxEq.EstatusId == 3) || vm.esAprobador == 1"/>
                                                    </td>
                                                </tr>
                                                <tr ng-if="vm.principal.length == 0" class="nodata-row">
                                                    <td colspan="8" class="text-center">
                                                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <br />
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer">
                         <button type="button" class="btn btn-info" ng-click="aprobar(FormaActualizacion)"  ng-show="vm.EstatusId == 1 && vm.esAprobador == 1">
                            <%= this.GetCommonMessage("lblTooltipAprobar") %>
                        </button>
                          <button type="button" class="btn btn-red" ng-click="rechazar(FormaActualizacion)"  ng-show="vm.EstatusId == 1 && vm.esAprobador == 1">
                            <%= this.GetCommonMessage("lblTooltipRechazar") %>
                        </button>
                          <button type="button" class="btn btn-info" ng-click="previo(FormaActualizacion)"  ng-show="(vm.EstatusId == 0 || vm.EstatusId == 4) && vm.esCrearModificar == 1">
                            <%= this.GetCommonMessage("lblTooltipGuardarPrevio") %>
                        </button>
                        <button type="button" class="btn btn-success" ng-click="guardar(FormaActualizacion)"  ng-show="(vm.EstatusId == 0 || vm.EstatusId == 4) && vm.esCrearModificar == 1">
                            <%= this.GetCommonMessage("lblTooltipGuardar") %>
                        </button>
                        <button type="button" class="btn btn-remove" data-dismiss="modal">
                            <%= this.GetMessage("lblTooltipCerrar") %> 
                        </button>
                    </div>
                </div>
            </div>
        </ui-modal>
        <ui-modal modal="modalHistorico">
            <div class="modal-dialog modal-lg" form="modalForm" style="width: 1200px;">
                <div class="modal-content" ng-form="FormaActualizacion">
                    <div class="modal-header" style="background-color: #00D067">
                        <h4 style="color: black; font-weight: 600; opacity: .9;" class="al-title" ng-show="vm.soloAprobador == 0">Histórico de check list</h4>
                        <h4 style="color: black; font-weight: 600; opacity: .9;" class="al-title" ng-show="vm.soloAprobador == 1">Mis Check List Pendientes de Revisión</h4>
                    </div>
                    <div class="modal-body" ng-class="{'submitted': submitted}" style="overflow: hidden">
                        <div class="view dashboard" style="margin-top: 0px; margin-bottom: 2px;" ng-show="vm.soloAprobador == 0">
                            <h1>Generales</h1> 
                            <div class="row mb">
                                <div class="col-sm-2">
                                     <span ng-show="vm.soloAprobador == 0">Código equipo</span>
                                </div>
                                <div class="col-sm-3"> 
                                     <input type="text" ng-model="vm.CodEquipo" class="control-label" disabled  ng-show="vm.soloAprobador == 0"/>
                                </div>         
                                <div class="col-sm-2">
                                     
                                </div>     
                                <div class="col-sm-4">
                                      <select class="form-control form-control-select" ng-model="vm.EstatusId" ng-change="vm.consultarhistorico(vm.EstatusId, vm.CodEquipo)"
                                            ng-options="item.EstatusId as item.Descripcion for item in vm.estatus"  ng-show="vm.soloAprobador == 0">
                                            <option value="" class="text-center">[ TODOS LOS ESTATUS ]</option>
                                        </select>
                                </div>  
                            </div>
                        </div>
                        <div class="row mb" style="margin-top: 0px;">
                            <div class="col-sm-12">
                                <div id="HomeHistorico" class="mail-box padding-10 wrapper border-bottom" style="margin-top: 0px;max-height:420px;">
                                    <br />
                                    <div ui-table="vm.tipoApoyoEvidenciaHIST" st-fixed style="width: 100%; max-height:200px;overflow-y: scroll;">
                                        <table class="jsgrid-table" style="width: 1130px; min-width: 1130px;"
                                            st-table="vm.tipoApoyoEvidenciaHIST" st-safe-src="vm.tipoApoyoEvidenciaHIST_">
                                            <thead>
                                                <tr>
                                                    <th id="primero" ui-field width="100" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvHistorico-IdChkEquipo") %></th>
                                                    <th ui-field width="100" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvHistorico-CodWorkCenter") %></th>
                                                    <th ui-field width="100" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvHistorico-CodEquipo") %></th>
                                                    <th ui-field width="100" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvHistorico-Estatus") %></th>
                                                    <th ui-field width="150" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvHistorico-UserAlta") %></th>
                                                    <th ui-field width="80" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvHistorico-FchAlta") %></th> 
                                                    <th ui-field width="80" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvHistorico-FechaIniciaFlujo") %></th>
                                                    <th ui-field width="150" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvHistorico-UserActiva") %></th>
                                                    <th ui-field width="80" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvHistorico-FechaFinalFlujo") %></th>
                                                    <th ui-field width="600" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvHistorico-DescripChkList") %></th>
                                                    <th ui-field width="150" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvHistorico-UserModif") %></th>
                                                    <th ui-field width="80" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvHistorico-FchEjecucion") %></th>
                                                    <th ui-field width="150" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvHistorico-UserCancela") %></th>
                                                    <th ui-field width="80" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvHistorico-FchCancel") %></th>
                                                     
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr ng-repeat="item in vm.tipoApoyoEvidenciaHIST">
                                                    <td st-ratio="100" class="text-center"> 
                                                          <button type="button" class="btn btn-link" ng-click="openModalNotasHistorico(item)">
                                                                   {{item.IdChkEquipo}}
                                                          </button>
                                                    </td>
                                                    <td st-ratio="100" class="text-center">{{item.CodWorkCenter}}</td>
                                                    <td st-ratio="100" class="text-center"> 
                                                        <button type="button" class="btn btn-link" ng-click="openModalNotasHistorico(item)">
                                                                   {{item.CodEquipo}}
                                                          </button>
                                                    </td> 
                                                    <td st-ratio="100" class="text-center">{{item.Estatus}}</td> 
                                                    <td st-ratio="150" class="text-center">{{item.UserAlta}}</td>
                                                    <td st-ratio="80" class="text-center">{{item.FchAlta}}</td>
                                                    <td st-ratio="80" class="text-center">{{item.FechaIniciaFlujo}}</td>
                                                    <td st-ratio="150" class="text-center">{{item.UserActiva}}</td>
                                                    <td st-ratio="80" class="text-center">{{item.FechaFinalFlujo}}</td>
                                                    <td st-ratio="600" class="text-center">{{item.DescripChkList}}</td>
                                                    <td st-ratio="150" class="text-center">{{item.UserModif}}</td>
                                                    <td st-ratio="80" class="text-center">{{item.FchEjecucion}}</td>
                                                    <td st-ratio="150" class="text-center">{{item.UserCancela}}</td>
                                                    <td st-ratio="80" class="text-center">{{item.FchCancel}}</td> 
                                                </tr> 
                                            </tbody>
                                        </table>
                                    </div>
                                    <br />
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer"> 
                        <button type="button" class="btn btn-remove" data-dismiss="modal">
                            <%= this.GetMessage("lblTooltipCerrar") %> 
                        </button>
                    </div>
                </div>
            </div>
        </ui-modal>
          <ui-modal modal="modalNotasHistorico">
            <div class="modal-dialog modal-lg" form="modalForm" style="width: 1200px;">
                <div class="modal-content" ng-form="FormaActualizacion">
                    <div class="modal-header" style="background-color: #2dacd1">
                        <h4 style="color: black; font-weight: 600; opacity: .9;" class="al-title">Histórico <%= this.GetMessage("TituloModal") %></h4>
                    </div>
                    <div class="modal-body" ng-class="{'submitted': submitted}" style="overflow: hidden">
                        <div class="view dashboard" style="margin-top: 0px; margin-bottom: 2px;">
                            <h1><%= this.GetMessage("TituloGeneral") %></h1>
                            <div class="row mb">
                                <div class="col-sm-1">
                                    <span style="color: #0069af"><%= this.GetMessage("IdChkEquipo") %></span>
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" ng-model="chklsxEqHistorico.IdChkEquipo" class="control-label" disabled />
                                </div>  
                                <div class="col-sm-1">
                                    <span style="color: #0069af"><%= this.GetMessage("Departamento") %></span>
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" ng-model="chklsxEqHistorico.CodDepartamento" class="control-label" disabled />
                                </div>     
                                 <div class="col-sm-1">
                                    <span style="color: #0069af"><%= this.GetMessage("Checklist") %></span>
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" ng-model="chklsxEqHistorico.CodChkList" class="control-label" disabled />
                                </div>   
                                <div class="col-sm-1">
                                    <span style="color: #0069af"><%= this.GetMessage("gvGeneral-WorkCenter") %></span>
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" ng-model="chklsxEqHistorico.WorkCenter" class="control-label" disabled />
                                    <input type="text" ng-model="chklsxEqHistorico.IdChkEquipo" class="control-label" ng-hide="true" /> 
                                     <input type="text" ng-model="chklsxEqHistorico.CodEquipo" class="control-label" ng-hide="true" />
                                </div>  
                            </div>
                            <div class="row mb">
                                <div class="col-sm-1">
                                    <span style="color: #0069af"><%= this.GetMessage("Nombre") %></span>
                                </div>
                                <div class="col-sm-7">
                                    <input type="text" ng-model="chklsxEqHistorico.ChkEquipo" class="control-label" style="width:540px" disabled />
                                </div>            
                                <div class="col-sm-1"></div>
                                <div class="col-sm-1">
                                    <span style="color: #0069af"><%= this.GetMessage("IdChecklist") %></span>
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" ng-model="chklsxEqHistorico.IdCheckList" class="control-label" disabled />
                                </div> 
                            </div>
                            <div class="row mb">
                                <div class="col-sm-1">
                                    <span style="color: #0069af"><%= this.GetMessage("Clasificacion") %></span>
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" ng-model="chklsxEqHistorico.CodClasif" class="control-label" disabled />
                                </div>                         
                                <div class="col-sm-1">
                                    <span style="color: #0069af"><%= this.GetMessage("Frecuencia") %></span>
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" ng-model="chklsxEqHistorico.Frecuencia" class="control-label" disabled />
                                </div>      
                                 <div class="col-sm-2">
                                    <span style="color: #0069af" class="text-left"><%= this.GetMessage("EstatusAprobacion") %></span>
                                </div>  
                                <div class="col-sm-3">
                                    <input type="text" ng-model="chklsxEqHistorico.Estatus" class="control-label" disabled />
                                </div>           
                            </div>
                            <div class="row mb">
                                <div class="col-sm-1">
                                    <span style="color: #0069af"><%= this.GetMessage("Periodo") %></span>
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" ng-model="chklsxEqHistorico.DesripFrencu" class="control-label" disabled />
                                </div>                         
                                <div class="col-sm-1">
                                    <span style="color: #0069af"><%= this.GetMessage("Estatus") %></span>
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" ng-model="chklsxEqHistorico.Activo" class="control-label" disabled />
                                </div>       
                                <div class="col-sm-2">
                                    <span style="color: #0069af"><%= this.GetMessage("FechaAprobacion") %></span>
                                </div>  
                                <div class="col-sm-3">
                                    <input type="text" ng-model="chklsxEqHistorico.FechaFlujo" class="control-label" disabled />
                                </div>         
                            </div>
                        </div>
                        <div class="row mb" style="margin-top: 0px;">
                            <div class="col-sm-12">
                                <div id="Home" class="mail-box padding-10 wrapper border-bottom" style="margin-top: 0px;max-height:320px;">
                                    <br />
                                    <div ui-table="vm.tipoApoyoEvidenciaHistorico" st-fixed style="width: 100%; max-height:250px;overflow-y: scroll;">
                                        <table class="jsgrid-table" style="width: 1130px; min-width: 1130px;"
                                            st-table="vm.tipoApoyoEvidenciaHistorico" st-safe-src="vm.tipoApoyoEvidenciaHistorico_">
                                            <thead>
                                                <tr> 
                                                    <th ui-field width="50" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-Orden") %></th>
                                                    <th ui-field width="100" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-Sistema") %></th>
                                                    <th ui-field width="150" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-Componente") %></th>
                                                    <th ui-field width="80" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-EquipoParado") %></th>
                                                    <th ui-field width="50" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-UoM") %></th>
                                                    <th id="ultimo" ui-field width="150" class="titulo3 text-center" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-Resultado") %></th>
                                                    <th ui-field width="1200" class="titulo3 text-left" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-Actividad") %></th>
                                                    <th ui-field width="500" class="titulo3 text-left" style="font-weight: bold;"><%= this.GetMessage("gvGeneral-Comentarios") %></th>

                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr ng-repeat="item in vm.tipoApoyoEvidenciaHistorico"> 
                                                    <td st-ratio="50" class="text-center">{{item.Orden}}</td>
                                                    <td st-ratio="100" class="text-center">{{item.DescripSistema}}</td>
                                                    <td st-ratio="150" class="text-center">{{item.DescripCompo}}</td>
                                                    <td st-ratio="80" class="text-center">{{item.EqParado}}</td>
                                                    <td st-ratio="50" class="text-center">{{item.CodUom}}</td>
                                                    <td st-ratio="150" class="text-center" ng-if="item.TipoOperacion == 'V'" >
                                                        <label class="radio-inline" ng-show="item.ResultVisual == 1"> 
                                                             <i class="fa fa-check"></i>
                                                        </label> 
                                                        <label class="radio-inline" ng-show="item.ResultVisual == 0"> 
                                                            <i class="fa fa-remove"></i>
                                                        </label>
                                                          <label class="radio-inline" ng-show="item.ResultVisual == NULL"> 
                                                           <span>No atendido</span>
                                                        </label>
                                                    </td> 
                                                    <td st-ratio="150" class="text-center" ng-if="item.TipoOperacion != 'V'">
                                                         <input type="text" ng-model="item.ResultMedible" class="control-label" required disabled />
                                                    </td>
                                                    <td st-ratio="500" class="text-center" >
                                                         <input type="text" ng-model="item.Comentarios" style="width:540px" class="control-label" required disabled="disabled"/>
                                                    </td>
                                                    <td st-ratio="1200" class="text-left">{{item.DescripcionAct}}</td>
                                                </tr>
                                                <tr ng-if="vm.principal.length == 0" class="nodata-row">
                                                    <td colspan="8" class="text-center">
                                                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <br />
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer"> 
                         <button type="button" class="btn btn-info" ng-click="aprobarHistorico(FormaActualizacion)"  ng-show="vm.EstatusId == 1 && vm.esAprobador == 1">
                            <%= this.GetCommonMessage("lblTooltipAprobar") %>
                        </button>
                          <button type="button" class="btn btn-red" ng-click="rechazarHistorico(FormaActualizacion)"  ng-show="vm.EstatusId == 1 && vm.esAprobador == 1">
                            <%= this.GetCommonMessage("lblTooltipRechazar") %>
                        </button>
                        <button type="button" class="btn btn-remove" data-dismiss="modal">
                            <%= this.GetMessage("lblTooltipCerrar") %> 
                        </button>
                    </div>
                </div>
            </div>
        </ui-modal>
        <script type="text/javascript" src="../Scripts/pages/inicioController.js?v=1.1<%=DateTime.Now.Millisecond %>"></script>
    </div>
</asp:Content>

