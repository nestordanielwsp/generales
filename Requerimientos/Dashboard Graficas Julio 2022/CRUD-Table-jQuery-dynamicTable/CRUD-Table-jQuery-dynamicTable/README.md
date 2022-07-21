# jquery.dynamicTable
A library that can help you to do CRUD operations on html table.

## Getting Started
Add table element to DOM

```
<table id="myTable" class="table table-bordered table-responsive table-striped" style="margin:0px auto auto auto;"></table>
```

### Prerequisites

The library depends on jquery, so jquery library must be added to html file.

## Setup

The parameters columns and data are compulsory. Here, getControl() function is optional.

```
<script
  src="http://code.jquery.com/jquery-3.2.1.slim.min.js"
  integrity="sha256-k2WSCIexGzOj3Euiig+TlR8gA0EmPjuc79OEeY5L45g="
  crossorigin="anonymous"></script>
  
<script src="js/jquery.dynamicTable-1.0.0.js" type="text/javascript"></script>

<script type="text/javascript">
    $(function () {
        $("#myTable").dynamicTable({
            columns: [{
                    text: "Name",
                    key: "name"
                },
                {
                    text: "Age",
                    key: "age"
                },
                {
                    text: "Gender",
                    key: "gender"
                },
            ],
            data: [{
                    name: 'Mr. Jeff Brown',
                    age: 30,
                    gender: 'M',
                },
                {
                    name: 'Ms. Rebeca John',
                    age: 24,
                    gender: 'F',
                },
            ],
            getControl: function (columnKey) {
                if (columnKey == "age") {
                    return '<input type="number" class="form-control" />';
                }

                if (columnKey == "gender") {
                    return '<select class="form-control"><option value="M">Male</option><option value="F">Female</option></select>';
                }

                return '<input type="text" class="form-control" />';
            },
        });
    });
</script>
```

## Getting Data

You can get data from dynamic table by just calling getTableData() function.
In following example a button added to DOM with id "btnGetData". You can get data after clicking on this button.

```
$('#btnGetData').click(function () {
    var data = $("#myTable").getTableData();
    console.log(data);
});
```
