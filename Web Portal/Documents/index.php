<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Connect Plus</title>
        <!-- plugins:css -->
        <link rel="stylesheet" href="assets/vendors/mdi/css/materialdesignicons.min.css">
        <link rel="stylesheet" href="assets/vendors/flag-icon-css/css/flag-icon.min.css">
        <link rel="stylesheet" href="assets/vendors/css/vendor.bundle.base.css">
        <!-- endinject -->
        <!-- Plugin css for this page -->
        <link rel="stylesheet" href="assets/vendors/font-awesome/css/font-awesome.min.css" />
        <link rel="stylesheet" href="assets/vendors/bootstrap-datepicker/bootstrap-datepicker.min.css">
        <link rel="stylesheet" href="assets/css/style.css">
        <!-- End layout styles -->
        <link rel="shortcut icon" href="assets/images/favicon.png" />
    </head>
    <body onload="today()">
        <div class="container-scroller">
            <!-- partial:partials/_navbar.html -->
            <nav class="navbar default-layout-navbar col-lg-12 col-12 p-0 fixed-top d-flex flex-row">
                <div class="text-center navbar-brand-wrapper d-flex align-items-center justify-content-center">
                    <a class="navbar-brand brand-logo" href="index.html"><img src="assets/images/logo.svg" alt="logo" /></a>
                    <a class="navbar-brand brand-logo-mini" href="index.html"><img src="assets/images/logo-mini.svg" alt="logo" /></a>
                </div>
                <div class="navbar-menu-wrapper d-flex align-items-stretch">
                    <button class="navbar-toggler navbar-toggler align-self-center" type="button" data-toggle="minimize">
                        <span class="mdi mdi-menu"></span>
                    </button>


                    <h1 class="navbar-nav mx-auto">Quick Kit</h1>

                    <button class="navbar-toggler navbar-toggler-right d-lg-none align-self-center" type="button" data-toggle="offcanvas">
                        <span class="mdi mdi-menu"></span>
                    </button>
                </div>
            </nav>
            <!-- partial -->
            <div class="container-fluid page-body-wrapper">
                <!-- partial:partials/_sidebar.html -->
                <nav class="sidebar sidebar-offcanvas" id="sidebar">
                    <ul class="nav">
                        <li class="nav-item nav-category"></li>

                        <li class="nav-item sidebar-user-actions">
                            <div class="user-details">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="d-flex align-items-center">
                                            <a class="nav-link" href="index.php">
                                                <span class="icon-bg"><i class="mdi mdi-cube menu-icon"></i></span>
                                                <span class="menu-title">Dashboard</span>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </li>
                        <li class="nav-item sidebar-user-actions">
                            <div class="sidebar-user-menu">
                                <a href="#" class="nav-link"><i class="mdi mdi-settings menu-icon"></i>
                                    <span class="menu-title">Settings</span>
                                </a>
                            </div>
                        </li>
                        <li class="nav-item sidebar-user-actions">
                            <div class="sidebar-user-menu">
                                <a href="#" class="nav-link"><i class="mdi mdi-logout menu-icon"></i>
                                    <span class="menu-title">Log Out</span></a>
                            </div>
                        </li>
                    </ul>
                </nav>
                <!-- partial -->
                <div class="main-panel">
                    <div class="content-wrapper">
                        <i id="bannerClose"></i>
                        <div class="d-xl-flex justify-content-between align-items-start">
                            <h2 class="text-dark font-weight-bold mb-2"> Dashboard </h2>
                            <div class="d-sm-flex justify-content-xl-between align-items-center mb-2">
                                <div class="btn-group bg-white p-3" role="group" aria-label="Basic example">
                                    <button type="button" id="today" class="btn btn-link text-dark py-0 border-right" onclick="today()">Today</button>
                                    <button type="button" id="week" class="btn btn-link text-light py-0 border-right" onclick="week()">This Week</button>
                                    <button type="button" id="month" class="btn btn-link text-light py-0" onclick="month()">This Month</button>
                                </div>

                            </div>
                        </div>
                        <script>
                            function today() {
                                document.getElementById("today").outerHTML = document.getElementById("today").outerHTML.replace("text-dark","text-light");
                                document.getElementById("week").outerHTML = document.getElementById("week").outerHTML.replace("text-dark","text-light");
                                document.getElementById("month").outerHTML = document.getElementById("month").outerHTML.replace("text-dark","text-light");
                                document.getElementById("today").outerHTML = document.getElementById("today").outerHTML.replace("text-light","text-dark");
                                document.getElementById("week").outerHTML = document.getElementById("week").outerHTML.replace("text-light","text-light");
                                document.getElementById("month").outerHTML = document.getElementById("month").outerHTML.replace("text-light","text-light");
                                $.ajax
                                ({
                                    type: "GET",
                                    dataType : 'json',
                                    async: false,
                                    url: 'saving.php',
                                    data: { data: JSON.stringify({"period":"subdate(current_date, 0)"}) },
                                    success: function () {alert("Thanks!"); },
                                    failure: function() {alert("Error!");}
                                });
                                reloadUI();  
                            }
                            function week() {
                                document.getElementById("today").outerHTML = document.getElementById("today").outerHTML.replace("text-dark","text-light");
                                document.getElementById("week").outerHTML = document.getElementById("week").outerHTML.replace("text-dark","text-light");
                                document.getElementById("month").outerHTML = document.getElementById("month").outerHTML.replace("text-dark","text-light");
                                document.getElementById("today").outerHTML = document.getElementById("today").outerHTML.replace("text-light","text-light");
                                document.getElementById("week").outerHTML = document.getElementById("week").outerHTML.replace("text-light","text-dark");
                                document.getElementById("month").outerHTML = document.getElementById("month").outerHTML.replace("text-light","text-light");
                                $.ajax
                                ({
                                    type: "GET",
                                    dataType : 'json',
                                    async: false,
                                    url: 'saving.php',
                                    data: { data: JSON.stringify({"period":"DATE_SUB(NOW(), INTERVAL 1 WEEK)"}) },
                                    success: function () {alert("Thanks!"); },
                                    failure: function() {alert("Error!");}
                                });
                                reloadUI();                               
                            }
                            function month() {
                                document.getElementById("today").outerHTML = document.getElementById("today").outerHTML.replace("text-dark","text-light");
                                document.getElementById("week").outerHTML = document.getElementById("week").outerHTML.replace("text-dark","text-light");
                                document.getElementById("month").outerHTML = document.getElementById("month").outerHTML.replace("text-dark","text-light");
                                document.getElementById("today").outerHTML = document.getElementById("today").outerHTML.replace("text-light","text-light");
                                document.getElementById("week").outerHTML = document.getElementById("week").outerHTML.replace("text-light","text-light");
                                document.getElementById("month").outerHTML = document.getElementById("month").outerHTML.replace("text-light","text-dark");
                                $.ajax
                                ({
                                    type: "GET",
                                    dataType : 'json',
                                    async: false,
                                    url: 'saving.php',
                                    data: { data: JSON.stringify({"period":"DATE_SUB(NOW(), INTERVAL 1 MONTH)"}) },
                                    success: function () {

                                        alert("Thanks!"); },
                                    failure: function() {alert("Error!");}
                                });
                                reloadUI();
                            }
                            function reloadUI() {
                                $.ajax
                                ({
                                    dataType : 'html',
                                    async: false,
                                    url: 'orders.php',
                                    success: function (data) {
                                        document.getElementById("tester").innerHTML = data;
                                    },
                                    failure: function() {alert("Error!");}
                                });
                                $.ajax
                                ({
                                    dataType : 'html',
                                    async: false,
                                    url: 'stats.php',
                                    success: function (data) {
                                        document.getElementById("stats").innerHTML = data;
                                    },
                                    failure: function() {alert("Error!");}
                                });
                            }
                            function reprint(orderNumber){

                                $.ajax({
                                    url: 'reprint.php',
                                    type: 'GET',
                                    data: { data: orderNumber },
                                    success: function (response) {
                                    },
                                    error: function () {
                                        alert("error");
                                    }
                                }); 
                            }
                        </script>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="d-sm-flex justify-content-between align-items-center transaparent-tab-border {">
                                    <ul class="nav nav-tabs tab-transparent" role="tablist">
                                        <li class="nav-item">
                                            <a class="nav-link active" id="sales-tab" data-toggle="tab" href="#sales-1" role="tab" aria-selected="true">Sales</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link " id="items-tab" data-toggle="tab" href="#items-1" role="tab" aria-selected="false">Items</a>
                                        </li>
                                    </ul>
                                </div>
                                <div class="tab-content tab-transparent-content">
                                    <div class="tab-pane fade show active" id="sales-1" role="tabpanel" aria-labelledby="sales-tab">
                                        <div class="row" id="stats">


                                        </div>
                                        <div class="col-lg-12 grid-margin stretch-card">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h4 class="card-title">Orders</h4>
                                                    <table class="table table-hover">
                                                        <thead>
                                                            <tr>
                                                                <th> # </th>
                                                                <th> Name </th>
                                                                <th> Payment </th>
                                                                <th> Amount </th>
                                                                <th> Collection </th>
                                                                <th> Reprint </th>
                                                            </tr>
                                                        </thead>
                                                        <tbody id="tester">

                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="tab-pane fade" id="items-1" role="tabpanel" aria-labelledby="items-tab">
                                        <div class="row">
                                            <div class="col-xl-3 col-lg-6 col-sm-6 grid-margin stretch-card">
                                                <div class="card">
                                                    <div class="card-body text-center">
                                                        <h5 class="mb-2 text-dark font-weight-normal">Orders</h5>
                                                        <h2 class="mb-4 text-dark font-weight-bold">932.00</h2>
                                                        <div class="dashboard-progress dashboard-progress-1 d-flex align-items-center justify-content-center item-parent"><i class="mdi mdi-lightbulb icon-md absolute-center text-dark"></i></div>
                                                        <p class="mt-4 mb-0">Completed</p>
                                                        <h3 class="mb-0 font-weight-bold mt-2 text-dark">5443</h3>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="search-field d-none d-xl-block">
                                                <form class="d-flex align-items-center h-100" action="#">
                                                    <div class="input-group">
                                                        <div class="input-group-prepend bg-transparent">
                                                            <i class="input-group-text border-0 mdi mdi-magnify"></i>
                                                        </div>
                                                        <input type="text" class="form-control bg-transparent border-0" placeholder="Search products">
                                                    </div>
                                                </form>
                                            </div>
                                            <div class="col-xl-3 col-lg-6 col-sm-6 grid-margin stretch-card">
                                                <div class="card">
                                                    <div class="card-body text-center">
                                                        <h5 class="mb-2 text-dark font-weight-normal">Unique Visitors</h5>
                                                        <h2 class="mb-4 text-dark font-weight-bold">756,00</h2>
                                                        <div class="dashboard-progress dashboard-progress-2 d-flex align-items-center justify-content-center item-parent"><i class="mdi mdi-account-circle icon-md absolute-center text-dark"></i></div>
                                                        <p class="mt-4 mb-0">Increased since yesterday</p>
                                                        <h3 class="mb-0 font-weight-bold mt-2 text-dark">50%</h3>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-xl-3  col-lg-6 col-sm-6 grid-margin stretch-card">
                                                <div class="card">
                                                    <div class="card-body text-center">
                                                        <h5 class="mb-2 text-dark font-weight-normal">Impressions</h5>
                                                        <h2 class="mb-4 text-dark font-weight-bold">100,38</h2>
                                                        <div class="dashboard-progress dashboard-progress-3 d-flex align-items-center justify-content-center item-parent"><i class="mdi mdi-eye icon-md absolute-center text-dark"></i></div>
                                                        <p class="mt-4 mb-0">Increased since yesterday</p>
                                                        <h3 class="mb-0 font-weight-bold mt-2 text-dark">35%</h3>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-xl-3 col-lg-6 col-sm-6 grid-margin stretch-card">
                                                <div class="card">
                                                    <div class="card-body text-center">
                                                        <h5 class="mb-2 text-dark font-weight-normal">Followers</h5>
                                                        <h2 class="mb-4 text-dark font-weight-bold">4250k</h2>
                                                        <div class="dashboard-progress dashboard-progress-4 d-flex align-items-center justify-content-center item-parent"><i class="mdi mdi-cube icon-md absolute-center text-dark"></i></div>
                                                        <p class="mt-4 mb-0">Decreased since yesterday</p>
                                                        <h3 class="mb-0 font-weight-bold mt-2 text-dark">25%</h3>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-12 grid-margin">
                                                <div class="card">
                                                    <div class="card-body">
                                                        <div class="row">
                                                            <div class="col-sm-12">
                                                                <div class="d-flex justify-content-between align-items-center mb-4">
                                                                    <h4 class="card-title mb-0">Recent Activity</h4>
                                                                    <div class="dropdown dropdown-arrow-none">
                                                                        <button class="btn p-0 text-dark dropdown-toggle" type="button" id="dropdownMenuIconButton1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                                            <i class="mdi mdi-dots-vertical"></i>
                                                                        </button>
                                                                        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="dropdownMenuIconButton1">
                                                                            <h6 class="dropdown-header">Settings</h6>
                                                                            <a class="dropdown-item" href="#">Action</a>
                                                                            <a class="dropdown-item" href="#">Another action</a>
                                                                            <a class="dropdown-item" href="#">Something else here</a>
                                                                            <div class="dropdown-divider"></div>
                                                                            <a class="dropdown-item" href="#">Separated link</a>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="col-lg-3 col-sm-4 grid-margin  grid-margin-lg-0">
                                                                <div class="wrapper pb-5 border-bottom">
                                                                    <div class="text-wrapper d-flex align-items-center justify-content-between mb-2">
                                                                        <p class="mb-0 text-dark">Total Profit</p>
                                                                        <span class="text-success"><i class="mdi mdi-arrow-up"></i>2.95%</span>
                                                                    </div>
                                                                    <h3 class="mb-0 text-dark font-weight-bold">$ 92556</h3>
                                                                    <canvas id="total-profit"></canvas>
                                                                </div>
                                                                <div class="wrapper pt-5">
                                                                    <div class="text-wrapper d-flex align-items-center justify-content-between mb-2">
                                                                        <p class="mb-0 text-dark">Expenses</p>
                                                                        <span class="text-success"><i class="mdi mdi-arrow-up"></i>52.95%</span>
                                                                    </div>
                                                                    <h3 class="mb-4 text-dark font-weight-bold">$ 59565</h3>
                                                                    <canvas id="total-expences"></canvas>
                                                                </div>
                                                            </div>
                                                            <div class="col-lg-9 col-sm-8 grid-margin  grid-margin-lg-0">
                                                                <div class="pl-0 pl-lg-4 ">
                                                                    <div class="d-xl-flex justify-content-between align-items-center mb-2">
                                                                        <div class="d-lg-flex align-items-center mb-lg-2 mb-xl-0">
                                                                            <h3 class="text-dark font-weight-bold mr-2 mb-0">Devices sales</h3>
                                                                            <h5 class="mb-0">( growth 62% )</h5>
                                                                        </div>
                                                                        <div class="d-lg-flex">
                                                                            <p class="mr-2 mb-0">Timezone:</p>
                                                                            <p class="text-dark font-weight-bold mb-0">GMT-0400 Eastern Delight Time</p>
                                                                        </div>
                                                                    </div>
                                                                    <div class="graph-custom-legend clearfix" id="device-sales-legend"></div>
                                                                    <canvas id="device-sales"></canvas>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-4 grid-margin stretch-card">
                                                <div class="card card-danger-gradient">
                                                    <div class="card-body mb-4">
                                                        <h4 class="card-title text-white">Account Retention</h4>
                                                        <canvas id="account-retension"></canvas>
                                                    </div>
                                                    <div class="card-body bg-white pt-4">
                                                        <div class="row pt-4">
                                                            <div class="col-sm-6">
                                                                <div class="text-center border-right border-md-0">
                                                                    <h4>Conversion</h4>
                                                                    <h1 class="text-dark font-weight-bold mb-md-3">$306</h1>
                                                                </div>
                                                            </div>
                                                            <div class="col-sm-6">
                                                                <div class="text-center">
                                                                    <h4>Cancellation</h4>
                                                                    <h1 class="text-dark font-weight-bold">$1,520</h1>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-sm-8  grid-margin stretch-card">
                                                <div class="card">
                                                    <div class="card-body">
                                                        <div class="d-xl-flex justify-content-between mb-2">
                                                            <h4 class="card-title">Page views analytics</h4>
                                                            <div class="graph-custom-legend primary-dot" id="pageViewAnalyticLengend"></div>
                                                        </div>
                                                        <canvas id="page-view-analytic"></canvas>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- content-wrapper ends -->
                    <!-- partial:partials/_footer.html -->
                    <footer class="footer">
                        <div class="footer-inner-wraper">
                            <div class="d-sm-flex justify-content-center justify-content-sm-between">
                                <span class="text-muted d-block text-center text-sm-left d-sm-inline-block">Copyright © bootstrapdash.com 2020</span>
                                <span class="float-none float-sm-right d-block mt-1 mt-sm-0 text-center"> Free <a href="https://www.bootstrapdash.com/" target="_blank">Bootstrap dashboard templates</a> from Bootstrapdash.com</span>
                            </div>
                        </div>
                    </footer>
                    <!-- partial -->
                </div>
                <!-- main-panel ends -->
            </div>
            <!-- page-body-wrapper ends -->
        </div>
        <!-- container-scroller -->
        <!-- plugins:js -->
        <script src="assets/vendors/js/vendor.bundle.base.js"></script>
        <!-- endinject -->
        <!-- Plugin js for this page -->
        <script src="assets/vendors/chart.js/Chart.min.js"></script>
        <script src="assets/vendors/jquery-circle-progress/js/circle-progress.min.js"></script>
        <!-- End plugin js for this page -->
        <!-- inject:js -->
        <script src="assets/js/off-canvas.js"></script>
        <script src="assets/js/hoverable-collapse.js"></script>
        <script src="assets/js/misc.js"></script>
        <!-- endinject -->
        <!-- Custom js for this page -->
        <script src="assets/js/dashboard.js"></script>
        <!-- End custom js for this page -->
    </body>
</html>