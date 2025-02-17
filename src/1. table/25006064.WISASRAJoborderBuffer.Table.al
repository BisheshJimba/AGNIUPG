table 25006064 "WIS/ASRA Joborder Buffer"
{

    fields
    {
        field(10; "Entry No."; Integer)
        {
        }
        field(20; "Entry Type"; Option)
        {
            OptionMembers = "File Pre-Run Record","Job Order Header Data","Customer Request","Order Item - Operation Number","Order Item - Damage Code";
        }
        field(30; Version; Text[9])
        {
            Description = 'File Pre-Run Record';
        }
        field(40; "Record Type"; Text[2])
        {
            Description = 'For all records';
        }
        field(50; Group; Text[2])
        {
            Description = 'Job Order Header Data';
        }
        field(60; Date; Text[10])
        {
            Description = 'Job Order Header Data';
        }
        field(70; Time; Text[5])
        {
            Description = 'Job Order Header Data/Order Item - Operation Number';
        }
        field(80; VIN; Text[17])
        {
            Description = 'Job Order Header Data';
        }
        field(90; Error; Text[2])
        {
            Description = 'Job Order Header Data';
        }
        field(100; Language; Text[2])
        {
            Description = 'Job Order Header Data';
        }
        field(110; Region; Text[2])
        {
            Description = 'Job Order Header Data';
        }
        field(120; "Production Country"; Text[2])
        {
            Description = 'Job Order Header Data';
        }
        field(130; "Family with description"; Text[250])
        {
            Description = 'Job Order Header Data';
        }
        field(140; "Type with model name"; Text[250])
        {
            Description = 'Job Order Header Data';
        }
        field(150; "Sales designation"; Text[250])
        {
            Description = 'Job Order Header Data';
        }
        field(160; "Engine Model"; Text[6])
        {
            Description = 'Job Order Header Data';
        }
        field(170; "Order No."; Text[250])
        {
            Description = 'Job Order Header Data';
        }
        field(180; "Client ID"; Text[250])
        {
            Description = 'Job Order Header Data';
        }
        field(190; "Text Customer Request"; Text[150])
        {
            Description = 'Customer Request';
        }
        field(200; "Design Group"; Text[2])
        {
            Description = 'Order Item - Operation Number';
        }
        field(210; "Operation Number"; Text[4])
        {
            Description = 'Order Item - Operation Number';
        }
        field(220; "Line Number"; Text[2])
        {
            Description = 'Order Item - Operation Number';
        }
        field(230; "Time Code"; Text[1])
        {
            Description = 'Order Item - Operation Number';
        }
        field(240; "Time Unit"; Text[1])
        {
            Description = 'Order Item - Operation Number';
        }
        field(250; "Search Criteria"; Text[150])
        {
            Description = 'Order Item - Operation Number';
        }
        field(260; "Activity (Job) Text"; Text[150])
        {
            Description = 'Order Item - Operation Number';
        }
        field(270; "Assembly Status"; Text[150])
        {
            Description = 'Order Item - Operation Number';
        }
        field(280; "Vehicle Configuration"; Text[150])
        {
            Description = 'Order Item - Operation Number';
        }
        field(290; "Damage Sign"; Text[1])
        {
            Description = 'Order Item - Damage Code';
        }
        field(300; "Damage Part"; Text[5])
        {
            Description = 'Order Item - Damage Code';
        }
        field(310; "Damage Type"; Text[3])
        {
            Description = 'Order Item - Damage Code';
        }
        field(320; "Repair Type"; Text[1])
        {
            Description = 'Order Item - Damage Code';
        }
        field(330; "Damage Part Text"; Text[150])
        {
            Description = 'Order Item - Damage Code';
        }
        field(340; "Damage Type Text"; Text[150])
        {
            Description = 'Order Item - Damage Code';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

