table 33020247 "Job Close Reasons"
{

    fields
    {
        field(1; "Service Order No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; Reason; Text[250])
        {
        }
        field(4; "Closed Date"; Date)
        {
        }
        field(5; "Closed By"; Code[50])
        {
        }
    }

    keys
    {
        key(Key1; "Service Order No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TESTFIELD("Service Order No.");
        TestServiceOrder;
        IF Reason <> '' THEN BEGIN
            CloseJob;
            "Closed Date" := TODAY;
            "Closed By" := USERID;
        END;
    end;

    trigger OnModify()
    begin
        TESTFIELD("Service Order No.");
        TestServiceOrder;
        IF Reason <> '' THEN BEGIN
            CloseJob;
            "Closed Date" := TODAY;
            "Closed By" := USERID;
        END;
    end;

    var
        ArchiveManagement: Codeunit "5063";
        ServLaborAllocationApp: Record "25006277";
        AllocationExists: Label 'Schedule Entry Exists for Service Order %1. First Deallocate the Schedule.';

    [Scope('Internal')]
    procedure CloseJob()
    var
        ServiceHeader: Record "25006145";
    begin

        ServiceHeader.RESET;
        ServiceHeader.SETRANGE("Document Type", ServiceHeader."Document Type"::Order);
        ServiceHeader.SETRANGE("No.", "Service Order No.");
        IF ServiceHeader.FINDFIRST THEN BEGIN
            ServiceHeader."Job Closed" := TRUE;
            ServiceHeader.MODIFY;
        END;
        ArchiveManagement.StoreServiceDocument(ServiceHeader, FALSE);
        DeleteServiceOrder(ServiceHeader);
    end;

    [Scope('Internal')]
    procedure DeleteServiceOrder(ServiceOrder: Record "25006145")
    var
        ServiceLine: Record "25006146";
    begin


        IF ServiceOrder.HASLINKS THEN ServiceOrder.DELETELINKS;

        //Lines
        ServiceLine.SETRANGE("Document Type", ServiceLine."Document Type"::Order);
        ServiceLine.SETRANGE("Document No.", ServiceOrder."No.");
        IF ServiceLine.FINDFIRST THEN
            REPEAT
                IF ServiceLine.HASLINKS THEN
                    ServiceLine.DELETELINKS;
            UNTIL ServiceLine.NEXT = 0;

        ServiceLine.DELETEALL;

        //Header
        ServiceOrder.DELETE;
    end;

    [Scope('Internal')]
    procedure TestServiceOrder()
    var
        ServiceLine: Record "25006146";
        QuantityError: Label 'Quantity must be 0 in Service Line before closing Job.';
    begin
        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", ServiceLine."Document Type"::Order);
        ServiceLine.SETRANGE("Document No.", "Service Order No.");
        IF ServiceLine.FINDSET THEN BEGIN
            REPEAT
                IF ServiceLine.Quantity > 0 THEN
                    ERROR(QuantityError);
            UNTIL ServiceLine.NEXT = 0;
        END;
        ServLaborAllocationApp.RESET;
        ServLaborAllocationApp.SETCURRENTKEY("Document Type", "Document No.", "Document Line No.");
        ServLaborAllocationApp.SETRANGE("Document Type", ServLaborAllocationApp."Document Type"::Order);
        ServLaborAllocationApp.SETRANGE("Document No.", "Service Order No.");
        ServLaborAllocationApp.SETRANGE("Time Line", TRUE);
        ServLaborAllocationApp.SETFILTER("Finished Quantity (Hours)", '>%1', 0);
        IF ServLaborAllocationApp.FINDFIRST THEN
            ERROR(AllocationExists, "Service Order No.");
    end;
}

