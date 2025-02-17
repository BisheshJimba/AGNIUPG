codeunit 33019970 "Get CT - No. Series"
{
    // Need to modify later to accomplish the location wise no. series management.


    trigger OnRun()
    begin
    end;

    var
        GlobalAdminSetup: Record "33019964";
        GlobalNoSeriesLine: Record "309";
        GlobalDocumentType: Option Transfer,Return;
        GlobalPostingType: Option Shipment,Receipt,Return;

    [Scope('Internal')]
    procedure getShipmentNo(ParmCourierTrackHdr: Record "33019987"): Code[20]
    begin
        GlobalAdminSetup.GET;

        //To pass as parameter to TestNo. Series and GetNoSeries.
        GlobalDocumentType := ParmCourierTrackHdr."Document Type";
        GlobalPostingType := GlobalPostingType::Shipment;

        //Testing admin. setup for Shipment Nos.
        testNoSeries(GlobalDocumentType, GlobalPostingType);

        //Getting Last no. used for Shipment No.
        GlobalNoSeriesLine.RESET;
        GlobalNoSeriesLine.SETRANGE("Series Code", getNoSeries(GlobalDocumentType, GlobalPostingType));
        GlobalNoSeriesLine.SETFILTER("Starting Date", '%1..%2', 0D, ParmCourierTrackHdr."Posting Date");
        GlobalNoSeriesLine.SETRANGE(Open, TRUE);
        IF GlobalNoSeriesLine.FIND('-') THEN BEGIN
            IF (GlobalNoSeriesLine."Last No. Used" <> '') THEN
                EXIT(INCSTR(GlobalNoSeriesLine."Last No. Used"))
            ELSE
                EXIT(INCSTR(GlobalNoSeriesLine."Starting No."));
        END;
    end;

    [Scope('Internal')]
    procedure getReceiptNo(ParmCourierTrackHdr2: Record "33019987"): Code[20]
    begin
        GlobalAdminSetup.GET;

        //To pass as parameter to TestNo. Series and GetNoSeries.
        GlobalDocumentType := ParmCourierTrackHdr2."Document Type";
        GlobalPostingType := GlobalPostingType::Receipt;

        //Testing admin. setup for Receipt Nos.
        testNoSeries(GlobalDocumentType, GlobalPostingType);

        //Getting Last no. used for Receipt No.
        GlobalNoSeriesLine.RESET;
        GlobalNoSeriesLine.SETRANGE("Series Code", getNoSeries(GlobalDocumentType, GlobalPostingType));
        GlobalNoSeriesLine.SETFILTER("Starting Date", '%1..%2', 0D, ParmCourierTrackHdr2."Posting Date");
        GlobalNoSeriesLine.SETRANGE(Open, TRUE);
        IF GlobalNoSeriesLine.FIND('-') THEN BEGIN
            IF (GlobalNoSeriesLine."Last No. Used" <> '') THEN
                EXIT(INCSTR(GlobalNoSeriesLine."Last No. Used"))
            ELSE
                EXIT(INCSTR(GlobalNoSeriesLine."Starting No."));
        END;
    end;

    [Scope('Internal')]
    procedure getReturnShipNo(ParmCourierTrackHdr3: Record "33019987"): Code[20]
    begin
        GlobalAdminSetup.GET;

        //To pass as parameter to TestNo. Series and GetNoSeries.
        GlobalDocumentType := ParmCourierTrackHdr3."Document Type";
        GlobalPostingType := GlobalPostingType::Return;

        //Testing admin. setup for Return Shipment Nos.
        testNoSeries(GlobalDocumentType, GlobalPostingType);

        //Getting Last no. used for Return Shipment No.
        GlobalNoSeriesLine.RESET;
        GlobalNoSeriesLine.SETRANGE("Series Code", getNoSeries(GlobalDocumentType, GlobalPostingType));
        GlobalNoSeriesLine.SETFILTER("Starting Date", '%1..%2', 0D, ParmCourierTrackHdr3."Posting Date");
        GlobalNoSeriesLine.SETRANGE(Open, TRUE);
        IF GlobalNoSeriesLine.FIND('-') THEN BEGIN
            IF (GlobalNoSeriesLine."Last No. Used" <> '') THEN
                EXIT(INCSTR(GlobalNoSeriesLine."Last No. Used"))
            ELSE
                EXIT(INCSTR(GlobalNoSeriesLine."Starting No."));
        END;
    end;

    [Scope('Internal')]
    procedure testNoSeries(ParmDocType: Option Transfer,Return; ParmPostingType: Option Shipment,Receipt,Return): Boolean
    begin
        CASE ParmDocType OF
            ParmDocType::Transfer:
                CASE ParmPostingType OF
                    ParmPostingType::Shipment:
                        GlobalAdminSetup.TESTFIELD("Transfer Shipment No.");
                    ParmPostingType::Receipt:
                        GlobalAdminSetup.TESTFIELD("Transfer Receipt No.");
                END;
            ParmDocType::Return:
                GlobalAdminSetup.TESTFIELD("Return Shipment No.");
        END;
    end;

    [Scope('Internal')]
    procedure getNoSeries(ParmDocType: Option Transfer,Return; ParmPostingType: Option Shipment,Receipt,Return): Code[20]
    begin
        CASE ParmDocType OF
            ParmDocType::Transfer:
                CASE ParmPostingType OF
                    ParmPostingType::Shipment:
                        EXIT(GlobalAdminSetup."Transfer Shipment No.");
                    ParmPostingType::Receipt:
                        EXIT(GlobalAdminSetup."Transfer Receipt No.");
                END;
            ParmDocType::Return:
                EXIT(GlobalAdminSetup."Return Shipment No.");
        END;
    end;

    [Scope('Internal')]
    procedure updateNoSeries(ParmCourierTrackHdr3: Record "33019987"; ParmPostType: Option Shipment,Receipt,Return; ParmPostingDate: Date; ParmLastNoUsed: Code[20])
    var
        LocalNoSeriesLine: Record "309";
        LocalDocType: Option Transfer,Return;
    begin
        //To update last no. used in No. Series Line.
        LocalDocType := ParmCourierTrackHdr3."Document Type";

        LocalNoSeriesLine.RESET;
        LocalNoSeriesLine.SETRANGE("Series Code", getNoSeries(LocalDocType, ParmPostType));
        LocalNoSeriesLine.SETFILTER("Starting Date", '%1..%2', 0D, ParmPostingDate);
        LocalNoSeriesLine.SETRANGE(Open, TRUE);
        IF LocalNoSeriesLine.FIND('-') THEN BEGIN
            LocalNoSeriesLine."Last Date Used" := TODAY;
            LocalNoSeriesLine."Last No. Used" := ParmLastNoUsed;
            LocalNoSeriesLine.MODIFY;
        END;
    end;
}

