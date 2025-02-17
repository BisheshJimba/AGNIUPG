table 25006019 "Vehicle Serial No. Buffer"
{
    Caption = 'Vehicle Serial No. Buffer';
    LookupPageID = 25006052;

    fields
    {
        field(10; "Serial No."; Code[20])
        {
            Caption = 'Serial No.';
        }
        field(20; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(30; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make Code));
        }
        field(50;"Customer No.";Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(60;Description;Text[30])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1;"Serial No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        fAssignSerialNo
    end;

    [Scope('Internal')]
    procedure fAssignSerialNo()
    var
        cuNoSeriesMgt: Codeunit "396";
        recPurchaseLine: Record "39";
        codSerialNos: Code[20];
        codNewSerialNo: Code[20];
        tcDMS001: Label '%1 is already assigned.';
    begin
        IF "Serial No." <> '' THEN
         ERROR(tcDMS001,FIELDCAPTION("Serial No."));

        codSerialNos := 'AUTOSN';
        cuNoSeriesMgt.InitSeries(codSerialNos,codSerialNos,WORKDATE,codNewSerialNo,codSerialNos);
          IF codNewSerialNo <> '' THEN
           BEGIN
            VALIDATE("Serial No.",codNewSerialNo);
           END;
    end;
}

