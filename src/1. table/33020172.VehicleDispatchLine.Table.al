table 33020172 "Vehicle Dispatch Line"
{

    fields
    {
        field(1; "Document No"; Code[20])
        {
            TableRelation = "Vehicle Dispatch Header".No.;
        }
        field(2; "Sales Invoice No."; Code[20])
        {
            Editable = false;
            TableRelation = "Sales Invoice Header";

            trigger OnLookup()
            var
                SalesInvHeader: Record "112";
                SalesInvList: Page "143";
            begin
                CLEAR(SalesInvList);
                IF "Sales Invoice No." <> '' THEN
                    IF SalesInvHeader.GET("Sales Invoice No.") THEN
                        SalesInvList.SETRECORD(SalesInvHeader);

                SalesInvHeader.SETRANGE("Document Profile", SalesInvHeader."Document Profile"::"Vehicles Trade");
                VehDispatchHeader.GET("Document No");
                SalesInvHeader.SETRANGE("Vehicle Location", VehDispatchHeader."Transfer-from Code");
                SalesInvHeader.SETRANGE(Dispatched, FALSE);
                SalesInvList.SETTABLEVIEW(SalesInvHeader);
                SalesInvList.LOOKUPMODE(TRUE);
                IF SalesInvList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    SalesInvList.GETRECORD(SalesInvHeader);
                    VALIDATE("Sales Invoice No.", SalesInvHeader."No.");
                    VALIDATE("Vehicle Serial No.", SalesInvHeader."Vehicle Sr. No.");
                    VALIDATE("Customer No.", SalesInvHeader."Bill-to Customer No.");
                    "Customer Name" := SalesInvHeader."Bill-to Name";
                END;
            end;
        }
        field(3; "Customer No."; Code[20])
        {
            Editable = false;
            TableRelation = Customer;
        }
        field(4; "Vehicle Serial No."; Code[20])
        {
            FieldClass = Normal;

            trigger OnValidate()
            begin
                Vehicle.GET("Vehicle Serial No.");
                VIN := Vehicle.VIN;
            end;
        }
        field(5; VIN; Code[20])
        {
            Editable = false;
        }
        field(50000; "Customer Name"; Text[50])
        {
            Editable = false;
        }
        field(50001; "Driver's Name"; Text[50])
        {
        }
        field(50002; "Fuel Qty."; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Document No", "Sales Invoice No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        VehDispatchHeader.GET("Document No");
        VehDispatchHeader.TESTFIELD(Dispatched, FALSE);
        VehDispatchHeader.TESTFIELD(Received, FALSE);
    end;

    trigger OnInsert()
    begin
        VehDispatchHeader.GET("Document No");
        VehDispatchHeader.TESTFIELD(Dispatched, FALSE);
        VehDispatchHeader.TESTFIELD(Received, FALSE);
        SETRANGE("Document No");
        IF FINDFIRST THEN
            ERROR('You cannot select more than one vehicle.');
    end;

    trigger OnModify()
    begin
        VehDispatchHeader.GET("Document No");
        VehDispatchHeader.TESTFIELD(Dispatched, FALSE);
        VehDispatchHeader.TESTFIELD(Received, FALSE);
    end;

    var
        Vehicle: Record "25006005";
        VehDispatchHeader: Record "33020171";
}

