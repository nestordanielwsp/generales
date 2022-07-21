(function () {
    'use strict';

    angular.module(appName)
        .controller('inicioController', inicioController);

    inicioController.$inject = ['$scope', '$http', '$rootScope'];

    function inicioController($scope, $http, $rootScope) {
        var service = $Ex;
        service.Http = $http;
        var vm = this;
        vm.viewDetail = false;
        vm.titulo = Ex.GetResourceValue("Titulo") || '';
        vm.isValid = true;
        vm.principal = [];
        vm.resultado = [];
        vm.linea = [];
        vm.usuario = {};
        vm.usuario.Loggeado = LoggeadoInfo;
        vm.esCrearModificar = esCrearModificarInfo;
        vm.esAprobador = esAprobadorInfo;
        vm.soloAprobador = false;
        vm.hasLogin = hasLogin;
        vm.hasLinea = tieneLinea;
        vm.hasDepto = tieneDepto;
        vm.hasEstatus = tieneEstatus;
       
        vm.rojo = 0;
        vm.amarillo = 0;
        vm.verde = 0;
        vm.lineaAll = LineaInfo;
        vm.depto = DeptoInfo;
        vm.estatus = EstatusInfo; 

        vm.EstatusId = 0;
        vm.CodEquipo = "";

        var date = new Date();
        var dd = date.getDate();
        var mm = date.getMonth();
        var aaaa = date.getFullYear();
        vm.diaHoy = new Date(aaaa, mm, dd);



        $scope.numeroAleatorio = function (min, max) {
            return Math.round(Math.random() * (max - min) + min);
        }


        $scope.llenarLinea = function (item) {
            // vm.linea = _.find(vm.lineaAll, { Depto: item });
            try {
                Ex.load(true);
                debugger;
                var datos = { Depto: item };
                service.Execute('GetLinea', datos, function (response) {
                    if (response.d) {
                        vm.linea = response.d.Linea;
                    }
                    Ex.load(false);
                })
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }

        var tipoApoyoSeleccionada = {};
        $scope.openModalNotas = function (item) {

            try {
                Ex.load(true);
                $scope.chklsxEq = {};
                $scope.chklsxEq_ = {};
                var datos = { CodDepto: item.CodDepartamento, CodEquipo: item.CodEquipo };
                vm.EstatusId = item.EstatusId;
                console.log('EstatusId: ' + vm.EstatusId);

                service.Execute('GetCheckListxEqEncPreCaptura', datos, function (response) {
                    if (response.d) {
                        if (response.d.Resultado.length > 0) {
                            $scope.chklsxEq = response.d.Resultado[0];
                            $scope.chklsxEq_ = angular.copy($scope.chklsxEq);


                            vm.tipoApoyoEvidencia = [];
                            vm.tipoApoyoEvidencia_ = [];
                            var datos = { IdChkEquipo: $scope.chklsxEq.IdChkEquipo, CodDepto: $scope.chklsxEq.CodDepartamento, CodEquipo: $scope.chklsxEq.CodEquipo };
                            service.Execute('GetCheckListxEqDetPreCaptura', datos, function (response) {
                                if (response.d) {
                                    if (response.d.Resultado.length > 0) {
                                        vm.tipoApoyoEvidencia = response.d.Resultado;
                                        vm.tipoApoyoEvidencia_ = angular.copy(vm.tipoApoyoEvidencia);
                                    }
                                }
                            })


                        }
                    }
                })



            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }

            Ex.load(false);
            $scope.modalNotas.open();
        };
         
        $scope.openModalHistorico = function (item, soloAprobador) { 
            try {
                Ex.load(true);
                $scope.chklsxEqHIST = {};
                $scope.chklsxEqHIST_ = {};

                var _Id = 0;
                if (vm.esAprobador == 1) { _Id = 1; }

                var datos = { EstatusId: _Id, CodEquipo: item == null ? '' : item.CodEquipo};

                vm.soloAprobador = soloAprobador;
                console.log('openModalHistorico - soloAprobador: ' + vm.soloAprobador);

                vm.EstatusId = _Id;
                console.log('openModalHistorico - EstatusId: ' + vm.EstatusId);
                vm.CodEquipo = item == null ? '' : item.CodEquipo;
                console.log('openModalHistorico - CodEquipo: ' + vm.CodEquipo);

                service.Execute('GetCheckListxCapEncHistorico', datos, function (response) {
                    if (response.d) {
                        if (response.d.Resultado.length > 0) {
                            $scope.chklsxEqHIST = response.d.Resultado[0];
                            $scope.chklsxEqHIST_ = angular.copy($scope.chklsxEqHIST); 
                             debugger
                            vm.tipoApoyoEvidenciaHIST = [];
                            vm.tipoApoyoEvidenciaHIST_ = [];
                            vm.tipoApoyoEvidenciaHIST = response.d.Resultado;
                            vm.tipoApoyoEvidenciaHIST_ = angular.copy(vm.tipoApoyoEvidenciaHIST);
                        }
                    }
                })  
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }

            Ex.load(false);
            $scope.modalHistorico.open();
        };

        $scope.openModalNotasHistorico = function (item) {

            try {
                Ex.load(true);
                $scope.chklsxEqHistorico = {};
                $scope.chklsxEqHistorico_ = {};
                var datos = { IdChkEquipo: item.IdChkEquipo }; 

                vm.EstatusId = item.EstatusId;
                console.log('openModalNotasHistorico - EstatusId: ' + vm.EstatusId + ' - esAprobador: ' + vm.esAprobador);

                service.Execute('GetCheckListxEqEncNotasHistorico', datos, function (response) {
                    if (response.d) {
                        if (response.d.Resultado.length > 0) {
                            $scope.chklsxEqHistorico = response.d.Resultado[0];
                            $scope.chklsxEqHistorico_ = angular.copy($scope.chklsxEqHistorico);
                             
                            vm.tipoApoyoEvidenciaHistorico = [];
                            vm.tipoApoyoEvidenciaHistorico_ = [];

                            var datos = { IdChkEquipo: item.IdChkEquipo }; 
                            service.Execute('GetCheckListxEqDetNotasHistorico', datos, function (response) {
                                if (response.d) {
                                    if (response.d.Resultado.length > 0) {
                                        vm.tipoApoyoEvidenciaHistorico = response.d.Resultado;
                                        vm.tipoApoyoEvidenciaHistorico_ = angular.copy(vm.tipoApoyoEvidenciaHistorico);
                                    }
                                }
                            })


                        }
                    }
                })
                 
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }

            Ex.load(false);
            $scope.modalNotasHistorico.open();
        };

        $scope.guardar = function () {
            try {
                Ex.load(true);
                var datos = []; 
                datos.IdChkEquipo = $scope.chklsxEq.IdChkEquipo;
                datos.WorkCenter = $scope.chklsxEq.WorkCenter;
                datos.CodDepto = $scope.chklsxEq.CodDepartamento;
                datos.CodEquipo = $scope.chklsxEq.CodEquipo;
                datos.tipoApoyoEvidencia = vm.tipoApoyoEvidencia;
                service.Execute('Guardar', datos, function (response) {
                       debugger
                    if (response.d.Error === '') {
                        Ex.mensajes('Se guardó con exito!', 1);
                        $scope.modalNotas.close();
                        vm.consultar();
                    }
                    else {
                        Ex.mensajes(response.d.Error, 1);
                    }
                    Ex.load(false);
                })
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }
            
        $scope.previo = function () {
            try {
                Ex.load(true);
                var datos = [];
                datos.IdChkEquipo = $scope.chklsxEq.IdChkEquipo;
                datos.WorkCenter = $scope.chklsxEq.WorkCenter;
                datos.CodDepto = $scope.chklsxEq.CodDepartamento;
                datos.CodEquipo = $scope.chklsxEq.CodEquipo;
                datos.tipoApoyoEvidencia = vm.tipoApoyoEvidencia;
                service.Execute('Previo', datos, function (response) {
                    debugger
                    if (response.d.Error === '') {
                        Ex.mensajes('Se guardó previamente con exito!', 1);
                        $scope.modalNotas.close();
                        vm.consultar();
                    }
                    else {
                        Ex.mensajes(response.d.Error, 1);
                    }
                    Ex.load(false);
                })
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }

        $scope.aprobar = function () {
            try {
                Ex.load(true);
                var datos = [];
                datos.IdChkEquipo = $scope.chklsxEq.IdChkEquipo;
                datos.CodEquipo = $scope.chklsxEq.CodEquipo;
                datos.WorkCenter = $scope.chklsxEq.WorkCenter;
                datos.tipoApoyoEvidencia = vm.tipoApoyoEvidencia;
                service.Execute('Aprobar', datos, function (response) {
                    debugger
                    if (response.d.Error === '') {
                        Ex.mensajes('Se aprobó con exito!', 1);
                        $scope.modalNotas.close();
                        vm.consultar();
                    }
                    else {
                        Ex.mensajes(response.d.Error, 1);
                    }
                    Ex.load(false);
                })
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }

        $scope.rechazar = function () {
            try {
                Ex.load(true);
                var datos = [];
                datos.IdChkEquipo = $scope.chklsxEq.IdChkEquipo;
                datos.CodEquipo = $scope.chklsxEq.CodEquipo;
                datos.tipoApoyoEvidencia = vm.tipoApoyoEvidencia;
                datos.WorkCenter = $scope.chklsxEq.WorkCenter;
                service.Execute('Rechazar', datos, function (response) {
                    debugger
                    if (response.d.Error === '') {
                        Ex.mensajes('Se rechazó con exito!', 1);
                        $scope.modalNotas.close();
                        vm.consultar();
                    }
                    else {
                        Ex.mensajes(response.d.Error, 1);
                    }
                    Ex.load(false);
                })
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }

        var consultar = function (pIdLinea, pIdDepto, pColor, pIdEstatus) {
            try {
                Ex.load(true);
                vm.principal = [];
                vm.principal_ = angular.copy(vm.principal);
                //var datos = { Depto: pIdDepto, Linea: pIdLinea , Color: pColor || '' , Estatus = pIdEstatus };
                var datos = { Depto: pIdDepto, Linea: pIdLinea , Color: pColor || ''  };
                debugger;
                service.Execute('GetInformacion', datos, function (response) {
                    if (response.d) {
                        vm.principal = response.d.InformacionPrincipal;
                        vm.resultado = response.d.Resultado;
                        vm.principal_ = angular.copy(vm.principal);

                        vm.rojo = vm.resultado[0].Critico;

                        vm.amarillo = vm.resultado[0].Medio;

                        vm.verde = vm.resultado[0].Warning;


                    }
                    Ex.load(false);
                })
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }

        vm.consultar = function (pIdLinea, pIdDepto, pColor, pIdEstatus) {
            consultar(pIdLinea, pIdDepto, pColor, pIdEstatus);
        }

        var consultarhistorico = function (pIdEstatus, CodEquipo) {
            try {
                Ex.load(true);
                $scope.chklsxEqHIST = {};
                $scope.chklsxEqHIST_ = {};

                var _Id = pIdEstatus;
                if (vm.esAprobador == 1) { _Id = 1; }

                var datos = { EstatusId: _Id, CodEquipo: CodEquipo };
                 
                console.log('openModalHistorico - soloAprobador: ' + vm.soloAprobador);
                 
                vm.EstatusId = pIdEstatus;
                console.log('consultarhistorico - EstatusId: ' + vm.EstatusId);

                vm.CodEquipo = CodEquipo;
                console.log('consultarhistorico - CodEquipo: ' + vm.CodEquipo);

                service.Execute('GetCheckListxCapEncHistorico', datos, function (response) {
                    if (response.d) {
                        if (response.d.Resultado.length > 0) {
                            $scope.chklsxEqHIST = response.d.Resultado[0];
                            $scope.chklsxEqHIST_ = angular.copy($scope.chklsxEqHIST);
                            debugger
                            vm.tipoApoyoEvidenciaHIST = [];
                            vm.tipoApoyoEvidenciaHIST_ = [];
                            vm.tipoApoyoEvidenciaHIST = response.d.Resultado;
                            vm.tipoApoyoEvidenciaHIST_ = angular.copy(vm.tipoApoyoEvidenciaHIST);
                        }
                        else { 
                            vm.tipoApoyoEvidenciaHIST = [];
                            vm.tipoApoyoEvidenciaHIST_ = [];
                        }
                    }
                })
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }

        vm.consultarhistorico = function (pIdEstatus, CodEquipo) {
            consultarhistorico(pIdEstatus, CodEquipo);
        }

        $scope.aprobarHistorico = function () {
            try {
                Ex.load(true);
                var datos = [];
                datos.IdChkEquipo = $scope.chklsxEqHistorico.IdChkEquipo;
               
                service.Execute('Aprobar', datos, function (response) {
                    debugger
                    if (response.d.Error === '') {
                        Ex.mensajes('Se aprobó con exito!', 1);
                        $scope.modalNotasHistorico.close();
                        vm.consultarhistorico(0, vm.CodEquipo);
                        vm.consultar();
                    }
                    else {
                        Ex.mensajes(response.d.Error, 1);
                    }
                    Ex.load(false);
                })
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }

        $scope.rechazarHistorico = function () {
            try {
                Ex.load(true);
                var datos = [];
                datos.IdChkEquipo = $scope.chklsxEqHistorico.IdChkEquipo;
                
                service.Execute('Rechazar', datos, function (response) {
                    debugger
                    if (response.d.Error === '') {
                        Ex.mensajes('Se rechazó con exito!', 1);
                        $scope.modalNotasHistorico.close();
                        vm.consultarhistorico(0, vm.CodEquipo);
                        vm.consultar();
                    }
                    else {
                        Ex.mensajes(response.d.Error, 1);
                    }
                    Ex.load(false);
                })
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }

        var init = function () {
            debugger;
            if (vm.hasLogin === 1) {
                vm.DeptoId = vm.hasDepto;
                vm.LineaId = vm.hasLinea;
                vm.EstatusId = vm.hasEstatus;
                consultar(vm.hasLinea, vm.hasDepto, '', vm.EstatusId);
            }
            else
            {
                consultar('', 'MATR', '', 0);
            }
            vm.linea = vm.lineaAll;
        }


        init();


    }
})();