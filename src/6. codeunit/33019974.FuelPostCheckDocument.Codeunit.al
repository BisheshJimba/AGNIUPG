codeunit 33019974 "Fuel Post - Check Document"
{

    trigger OnRun()
    begin
    end;

    var
        GblDocAppEntry: Record "33019915";
        GblUserSetup: Record "91";

    [Scope('Internal')]
    procedure checkUserIssueLimit(ParmFuelIssueEntry: Record "33019963")
    var
        TotalFuelIssue: Decimal;
        Text33019962: Label 'Sorry, you donot have permission to issue more than - %1 litre of fuel at a time. Please get approval from concerned manager. \Or contact your system administrator.';
        Text33019963: Label 'Sorry, your fuel issue limit is upto - %1 litre. Please get approval from concerned manager. \Or contact your system administrator.';
    begin
        //Checking user wise fuel issue limit while posting fuel issue coupon.
        TotalFuelIssue := ParmFuelIssueEntry."Total Fuel Issued" + ParmFuelIssueEntry."Add. Total Fuel Issued";
        GblUserSetup.GET(USERID);
        IF (GblUserSetup."Approver ID" <> '') THEN BEGIN
            GblDocAppEntry.RESET;
            GblDocAppEntry.SETRANGE("Table ID", DATABASE::"Fuel Issue Entry");
            GblDocAppEntry.SETRANGE("Document Type", GblDocAppEntry."Document Type"::"Fuel Issue");
            GblDocAppEntry.SETRANGE("Document No.", ParmFuelIssueEntry."No.");
            IF GblDocAppEntry.FIND('-') THEN BEGIN
                IF GblDocAppEntry.Status <> GblDocAppEntry.Status::Approved THEN BEGIN
                    IF GblUserSetup."Fuel Issue Limit" <> 0 THEN BEGIN
                        IF GblUserSetup."Fuel Issue Limit" < TotalFuelIssue THEN
                            ERROR(Text33019962, GblUserSetup."Fuel Issue Limit");
                    END;
                END;
            END ELSE
                ERROR(Text33019963, GblUserSetup."Fuel Issue Limit");
        END;
    end;

    [Scope('Internal')]
    procedure checkMovementType(ParmFuelIssueEntry2: Record "33019963")
    var
        Text33019963: Label 'Please get approval from authorized person to issue fuel coupon for Movement Type::Demo.\Or contact your system administrator.';
        Text33019964: Label 'Sorry, you donot have permission to issue fuel for Movement Type::Demo. Please get approval from concerned manager. \Or contact your system administrator.';
    begin
        //Checking and restricting posting fuel coupon if movement type is Demo.
        IF ParmFuelIssueEntry2."Movement Type" = ParmFuelIssueEntry2."Movement Type"::Demo THEN BEGIN
            GblUserSetup.GET(USERID);
            IF (GblUserSetup."Approver ID" <> '') THEN BEGIN
                GblDocAppEntry.RESET;
                GblDocAppEntry.SETRANGE("Table ID", DATABASE::"Fuel Issue Entry");
                GblDocAppEntry.SETRANGE("Document Type", GblDocAppEntry."Document Type"::"Fuel Issue");
                GblDocAppEntry.SETRANGE("Document No.", ParmFuelIssueEntry2."No.");
                IF GblDocAppEntry.FIND('-') THEN BEGIN
                    IF GblDocAppEntry.Status <> GblDocAppEntry.Status::Approved THEN
                        ERROR(Text33019963);
                END ELSE
                    ERROR(Text33019964);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure CouponCheckDocument(PrmFuelIssueEntry: Record "33019963")
    begin
        //Checking Fuel Issue Entry table for empty fields - Case Coupon.
        PrmFuelIssueEntry.TESTFIELD(Location);
        PrmFuelIssueEntry.TESTFIELD("Issue Date");
        PrmFuelIssueEntry.TESTFIELD("Issue Type");
        PrmFuelIssueEntry.TESTFIELD("Issued For");
        //PrmFuelIssueEntry.TESTFIELD("Movement Type");

        IF (PrmFuelIssueEntry."Issue Type" = PrmFuelIssueEntry."Issue Type"::Department) THEN
            PrmFuelIssueEntry.TESTFIELD(Department)
        ELSE
            IF (PrmFuelIssueEntry."Issue Type" = PrmFuelIssueEntry."Issue Type"::Staff) THEN
                PrmFuelIssueEntry.TESTFIELD("Staff No.");

        IF (PrmFuelIssueEntry."Issued For" = PrmFuelIssueEntry."Issued For"::Vehicle) THEN BEGIN
            IF (PrmFuelIssueEntry."Movement Type" IN [PrmFuelIssueEntry."Movement Type"::Delivery,
            PrmFuelIssueEntry."Movement Type"::Demo]) THEN BEGIN
                //PrmFuelIssueEntry.TESTFIELD(Manufacturer);
                PrmFuelIssueEntry.TESTFIELD("VIN (Chasis No.)");
                //PrmFuelIssueEntry.TESTFIELD("Vehicle Type");
                PrmFuelIssueEntry.TESTFIELD(Mileage);
                PrmFuelIssueEntry.TESTFIELD("From City Code");
                PrmFuelIssueEntry.TESTFIELD("To City Code");
            END ELSE
                IF (PrmFuelIssueEntry."Movement Type" IN [PrmFuelIssueEntry."Movement Type"::Transfer,
       PrmFuelIssueEntry."Movement Type"::Repair, PrmFuelIssueEntry."Movement Type"::"Office Use",
       PrmFuelIssueEntry."Movement Type"::Tour]) THEN BEGIN
                    //PrmFuelIssueEntry.TESTFIELD(Manufacturer);
                    PrmFuelIssueEntry.TESTFIELD("VIN (Chasis No.)");
                    //PrmFuelIssueEntry.TESTFIELD("Vehicle Type");
                    PrmFuelIssueEntry.TESTFIELD(Mileage);
                    PrmFuelIssueEntry.TESTFIELD("Registration No.");
                    //PrmFuelIssueEntry.TESTFIELD("Vehicle Last Visit KM");
                    PrmFuelIssueEntry.TESTFIELD("From City Code");
                    PrmFuelIssueEntry.TESTFIELD("To City Code");
                END;
        END;

        PrmFuelIssueEntry.TESTFIELD("Petrol Pump Code");
        PrmFuelIssueEntry.TESTFIELD("Issued Coupon No.");
        PrmFuelIssueEntry.TESTFIELD("Fuel Type");
        PrmFuelIssueEntry.TESTFIELD("Rate (Rs.)");
        PrmFuelIssueEntry.TESTFIELD("Amount (Rs.)");
        PrmFuelIssueEntry.TESTFIELD("Issued To");
        PrmFuelIssueEntry.TESTFIELD("Purpose of Travel");
        //PrmFuelIssueEntry.TESTFIELD(Remarks);

        IF PrmFuelIssueEntry."Add Additional City" THEN BEGIN
            PrmFuelIssueEntry.TESTFIELD("Add. From City Code");
            PrmFuelIssueEntry.TESTFIELD("Add. To City Name");
            PrmFuelIssueEntry.TESTFIELD("Add. Distance");
            PrmFuelIssueEntry.TESTFIELD("Add. Litre");
        END;
    end;

    [Scope('Internal')]
    procedure StockCheckDocument(PrmFuelIssueEntry: Record "33019963")
    var
        LocalFuelIssueEntry2: Record "33019963";
    begin
        //Checking Fuel Issue Entry table for empty fields - Case Stock.
        PrmFuelIssueEntry.TESTFIELD(Location);
        PrmFuelIssueEntry.TESTFIELD("Issue Date");
        PrmFuelIssueEntry.TESTFIELD("Issue Type");
        PrmFuelIssueEntry.TESTFIELD("Issued For");
        PrmFuelIssueEntry.TESTFIELD("Movement Type");

        IF (PrmFuelIssueEntry."Issue Type" = PrmFuelIssueEntry."Issue Type"::Department) THEN
            PrmFuelIssueEntry.TESTFIELD(Department)
        ELSE
            IF (PrmFuelIssueEntry."Issue Type" = PrmFuelIssueEntry."Issue Type"::Staff) THEN
                PrmFuelIssueEntry.TESTFIELD("Staff No.");

        IF (PrmFuelIssueEntry."Issued For" = PrmFuelIssueEntry."Issued For"::Vehicle) THEN BEGIN
            IF (PrmFuelIssueEntry."Movement Type" IN [PrmFuelIssueEntry."Movement Type"::Delivery,
            PrmFuelIssueEntry."Movement Type"::Demo]) THEN BEGIN
                PrmFuelIssueEntry.TESTFIELD(Manufacturer);
                PrmFuelIssueEntry.TESTFIELD("VIN (Chasis No.)");
                //PrmFuelIssueEntry.TESTFIELD("Vehicle Type");
                PrmFuelIssueEntry.TESTFIELD(Mileage);
                PrmFuelIssueEntry.TESTFIELD("From City Code");
                PrmFuelIssueEntry.TESTFIELD("To City Code");
            END ELSE
                IF (PrmFuelIssueEntry."Movement Type" IN [PrmFuelIssueEntry."Movement Type"::Transfer,
       PrmFuelIssueEntry."Movement Type"::Repair, PrmFuelIssueEntry."Movement Type"::"Office Use",
       PrmFuelIssueEntry."Movement Type"::Tour]) THEN BEGIN
                    PrmFuelIssueEntry.TESTFIELD(Manufacturer);
                    PrmFuelIssueEntry.TESTFIELD("VIN (Chasis No.)");
                    //PrmFuelIssueEntry.TESTFIELD("Vehicle Type");
                    PrmFuelIssueEntry.TESTFIELD(Mileage);
                    PrmFuelIssueEntry.TESTFIELD("Registration No.");
                    //PrmFuelIssueEntry.TESTFIELD("Vehicle Last Visit KM");
                    PrmFuelIssueEntry.TESTFIELD("From City Code");
                    PrmFuelIssueEntry.TESTFIELD("To City Code");
                END;
        END;

        PrmFuelIssueEntry.TESTFIELD("Fuel Type");
        PrmFuelIssueEntry.TESTFIELD("Rate (Rs.)");
        PrmFuelIssueEntry.TESTFIELD("Amount (Rs.)");
        PrmFuelIssueEntry.TESTFIELD("Issued To");
        PrmFuelIssueEntry.TESTFIELD("Purpose of Travel");

        IF PrmFuelIssueEntry."Add Additional City" THEN BEGIN
            PrmFuelIssueEntry.TESTFIELD("Add. From City Code");
            PrmFuelIssueEntry.TESTFIELD("Add. To City Name");
            PrmFuelIssueEntry.TESTFIELD("Add. Distance");
            PrmFuelIssueEntry.TESTFIELD("Add. Litre");
        END;
    end;

    [Scope('Internal')]
    procedure CashCheckDocument(PrmFuelIssueEntry: Record "33019963")
    var
        LocalFuelIssueEntry3: Record "33019963";
    begin
        //Checking Fuel Issue Entry table for empty fields - Case Cash.
        PrmFuelIssueEntry.TESTFIELD(Location);
        PrmFuelIssueEntry.TESTFIELD("Issue Date");
        PrmFuelIssueEntry.TESTFIELD("Issue Type");
        PrmFuelIssueEntry.TESTFIELD("Issued For");
        PrmFuelIssueEntry.TESTFIELD("Movement Type");

        IF (PrmFuelIssueEntry."Issue Type" = PrmFuelIssueEntry."Issue Type"::Department) THEN
            PrmFuelIssueEntry.TESTFIELD(Department)
        ELSE
            IF (PrmFuelIssueEntry."Issue Type" = PrmFuelIssueEntry."Issue Type"::Staff) THEN
                PrmFuelIssueEntry.TESTFIELD("Staff No.");

        IF (PrmFuelIssueEntry."Issued For" = PrmFuelIssueEntry."Issued For"::Vehicle) THEN BEGIN
            IF (PrmFuelIssueEntry."Movement Type" IN [PrmFuelIssueEntry."Movement Type"::Delivery,
            PrmFuelIssueEntry."Movement Type"::Demo]) THEN BEGIN
                PrmFuelIssueEntry.TESTFIELD(Manufacturer);
                PrmFuelIssueEntry.TESTFIELD("VIN (Chasis No.)");
                //PrmFuelIssueEntry.TESTFIELD("Vehicle Type");
                PrmFuelIssueEntry.TESTFIELD(Mileage);
                PrmFuelIssueEntry.TESTFIELD("From City Code");
                PrmFuelIssueEntry.TESTFIELD("To City Code");
            END ELSE
                IF (PrmFuelIssueEntry."Movement Type" IN [PrmFuelIssueEntry."Movement Type"::Transfer,
       PrmFuelIssueEntry."Movement Type"::Repair, PrmFuelIssueEntry."Movement Type"::"Office Use",
       PrmFuelIssueEntry."Movement Type"::Tour]) THEN BEGIN
                    PrmFuelIssueEntry.TESTFIELD(Manufacturer);
                    PrmFuelIssueEntry.TESTFIELD("VIN (Chasis No.)");
                    //PrmFuelIssueEntry.TESTFIELD("Vehicle Type");
                    PrmFuelIssueEntry.TESTFIELD(Mileage);
                    PrmFuelIssueEntry.TESTFIELD("Registration No.");
                    //PrmFuelIssueEntry.TESTFIELD("Vehicle Last Visit KM");
                    PrmFuelIssueEntry.TESTFIELD("From City Code");
                    PrmFuelIssueEntry.TESTFIELD("To City Code");
                END;
        END;

        PrmFuelIssueEntry.TESTFIELD("Fuel Type");
        PrmFuelIssueEntry.TESTFIELD("Rate (Rs.)");
        PrmFuelIssueEntry.TESTFIELD("Amount (Rs.)");
        PrmFuelIssueEntry.TESTFIELD("Issued To");
        PrmFuelIssueEntry.TESTFIELD("Purpose of Travel");

        IF PrmFuelIssueEntry."Add Additional City" THEN BEGIN
            PrmFuelIssueEntry.TESTFIELD("Add. From City Code");
            PrmFuelIssueEntry.TESTFIELD("Add. To City Name");
            PrmFuelIssueEntry.TESTFIELD("Add. Distance");
            PrmFuelIssueEntry.TESTFIELD("Add. Litre");
        END;
    end;
}

