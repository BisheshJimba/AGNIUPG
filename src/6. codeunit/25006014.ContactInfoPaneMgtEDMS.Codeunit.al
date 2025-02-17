codeunit 25006014 "Contact Info-Pane Mgt. EDMS"
{

    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure LookupOpportunities(Cont: Record "5050")
    var
        Opp: Record "5092";
    begin
        FilterOpp(Opp, Cont);
        PAGE.RUNMODAL(PAGE::"Opportunity List", Opp)
    end;

    [Scope('Internal')]
    procedure CalcNoOfOpportunities(Cont: Record "5050"): Decimal
    var
        Opp: Record "5092";
    begin
        FilterOpp(Opp, Cont);
        EXIT(Opp.COUNT);
    end;

    [Scope('Internal')]
    procedure FilterOpp(var Opp: Record "5092"; Cont: Record "5050")
    begin
        Opp.RESET;
        Opp.SETCURRENTKEY("Contact Company No.", "Contact No.");
        Opp.SETRANGE("Contact Company No.", Cont."Company No.");
        IF Cont."Lookup Contact No." <> '' THEN
            Opp.SETRANGE("Contact No.", Cont."Lookup Contact No.");
    end;

    [Scope('Internal')]
    procedure LookupToDos(Cont: Record "5050")
    var
        ToDo: Record "5080";
    begin
        FilterToDo(ToDo, Cont);
        PAGE.RUNMODAL(PAGE::"To-do List", ToDo)
    end;

    [Scope('Internal')]
    procedure CalcNoOfToDos(Cont: Record "5050"): Decimal
    var
        ToDo: Record "5080";
    begin
        FilterToDo(ToDo, Cont);
        EXIT(ToDo.COUNT)
    end;

    [Scope('Internal')]
    procedure FilterToDo(var ToDo: Record "5080"; Cont: Record "5050")
    begin
        ToDo.RESET;
        ToDo.SETCURRENTKEY("Contact Company No.", Date, "Contact No.", Closed);
        ToDo.SETRANGE("Contact Company No.", Cont."Company No.");
        IF Cont."Lookup Contact No." <> '' THEN
            ToDo.SETRANGE("Contact No.", Cont."Lookup Contact No.");
        ToDo.SETRANGE("System To-do Type", ToDo."System To-do Type"::"Contact Attendee");
        ToDo.SETRANGE(Closed, FALSE)
    end;

    [Scope('Internal')]
    procedure LookupVehicles(Cont: Record "5050")
    var
        Vehicle: Record "25006005";
        Cont2: Record "5050";
    begin
        Vehicle.RESET;
        MarkContVehicles(Vehicle, Cont."No.");
        IF (Cont.Type = Cont.Type::Company) AND
           (Cont."Company No." <> '') THEN
            IF Cont2.GET(Cont."Company No.") THEN
                MarkContVehicles(Vehicle, Cont2."No.");

        Vehicle.MARKEDONLY(TRUE);
        PAGE.RUNMODAL(PAGE::"Vehicle List", Vehicle);
    end;

    [Scope('Internal')]
    procedure CalcNoOfVehicles(Cont: Record "5050"): Decimal
    var
        Vehicle: Record "25006005";
        Cont2: Record "5050";
    begin
        Vehicle.RESET;
        MarkContVehicles(Vehicle, Cont."No.");
        IF (Cont.Type = Cont.Type::Company) AND
           (Cont."Company No." <> '') THEN
            IF Cont2.GET(Cont."Company No.") THEN
                MarkContVehicles(Vehicle, Cont2."No.");

        Vehicle.MARKEDONLY(TRUE);
        EXIT(Vehicle.COUNT);
    end;

    [Scope('Internal')]
    procedure LookupSalesDocs(Cont: Record "5050"; Type: Integer)
    var
        SalesHeader: Record "36";
    begin
        FilterSalesDocs(SalesHeader, Cont, Type);
        CASE Type OF
            0:
                BEGIN
                    SalesHeader.SETRANGE("Document Profile", SalesHeader."Document Profile"::"Vehicles Trade");
                    PAGE.RUNMODAL(PAGE::"Sales Quote", SalesHeader);
                END;
            1:
                PAGE.RUNMODAL(PAGE::"Sales Quote", SalesHeader);
            2:
                BEGIN
                    SalesHeader.SETRANGE("Document Profile", SalesHeader."Document Profile"::"Vehicles Trade");
                    PAGE.RUNMODAL(PAGE::"Sales Order", SalesHeader);
                END;
            3:
                PAGE.RUNMODAL(PAGE::"Sales Order", SalesHeader);
        END;
    end;

    [Scope('Internal')]
    procedure CalcNoOfSalesDocs(Cont: Record "5050"; Type: Integer): Decimal
    var
        SalesHeader: Record "36";
    begin
        FilterSalesDocs(SalesHeader, Cont, Type);
        CASE Type OF
            0, 1:
                SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Quote);
            2, 3:
                SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
        END;
        CASE Type OF
            0, 2:
                SalesHeader.SETRANGE("Document Profile", SalesHeader."Document Profile"::"Vehicles Trade");
            1, 3:
                SalesHeader.SETRANGE("Document Profile", SalesHeader."Document Profile"::"Spare Parts Trade");
        END;
        EXIT(SalesHeader.COUNT)
    end;

    [Scope('Internal')]
    procedure FilterSalesDocs(var SalesHeader: Record "36"; Cont: Record "5050"; Type: Integer)
    begin
        SalesHeader.RESET;
        SalesHeader.SETCURRENTKEY("Document Type", "Sell-to Contact No.");
        SalesHeader.SETRANGE("Sell-to Contact No.", Cont."No.");
    end;

    [Scope('Internal')]
    procedure LookupPostponedInt(Cont: Record "5050")
    var
        PostponedInt: Record "5065";
    begin
        FilterPostponedInt(PostponedInt, Cont);
        PAGE.RUNMODAL(PAGE::"Postponed Interactions", PostponedInt)
    end;

    [Scope('Internal')]
    procedure CalcNoOfPostponedInt(Cont: Record "5050"): Decimal
    var
        PostponedInt: Record "5065";
    begin
        FilterPostponedInt(PostponedInt, Cont);
        EXIT(PostponedInt.COUNT)
    end;

    [Scope('Internal')]
    procedure FilterPostponedInt(var PostponedInt: Record "5065"; Cont: Record "5050")
    begin
        PostponedInt.RESET;
        PostponedInt.SETCURRENTKEY("Contact Company No.", Date, "Contact No.", Canceled, "Initiated By", "Attempt Failed");
        PostponedInt.SETRANGE("Contact Company No.", Cont."Company No.");
        PostponedInt.SETRANGE(Postponed, TRUE);
        IF Cont."Lookup Contact No." <> '' THEN
            PostponedInt.SETRANGE("Contact No.", Cont."Lookup Contact No.");
    end;

    [Scope('Internal')]
    procedure LookupServiceDocs(Cont: Record "5050"; Type: Integer)
    var
        ServiceHeader: Record "25006145";
    begin
        FilterServiceDocs(ServiceHeader, Cont, Type);
        CASE Type OF
            0:
                PAGE.RUNMODAL(PAGE::"Service Quote EDMS", ServiceHeader);
            1:
                PAGE.RUNMODAL(PAGE::"Service Order EDMS", ServiceHeader);
        END;
    end;

    [Scope('Internal')]
    procedure CalcNoOfServiceDocs(Cont: Record "5050"; Type: Integer): Decimal
    var
        ServiceHeader: Record "25006145";
    begin
        FilterServiceDocs(ServiceHeader, Cont, Type);
        EXIT(ServiceHeader.COUNT)
    end;

    [Scope('Internal')]
    procedure FilterServiceDocs(var ServiceHeader: Record "25006145"; Cont: Record "5050"; Type: Integer)
    begin
        ServiceHeader.RESET;
        ServiceHeader.SETCURRENTKEY("Document Type", "Sell-to Contact No.");
        CASE Type OF
            0:
                ServiceHeader.SETRANGE("Document Type", ServiceHeader."Document Type"::Quote);
            1:
                ServiceHeader.SETRANGE("Document Type", ServiceHeader."Document Type"::Order);
        END;
        ServiceHeader.SETRANGE("Sell-to Contact No.", Cont."No.");
    end;

    [Scope('Internal')]
    procedure MarkContVehicles(var Vehicle: Record "25006005"; ContNo: Code[20])
    var
        VehicleContact: Record "25006013";
    begin
        VehicleContact.RESET;
        VehicleContact.SETCURRENTKEY("Contact No.");
        VehicleContact.SETRANGE("Contact No.", ContNo);
        IF VehicleContact.FINDFIRST THEN
            REPEAT
                IF Vehicle.GET(VehicleContact."Vehicle Serial No.") THEN
                    Vehicle.MARK := TRUE;
            UNTIL VehicleContact.NEXT = 0;
    end;
}

