pageextension 50186 pageextension50186 extends "Sales Orders"
{
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 33".

    }

    //Unsupported feature: Code Insertion on "OnOpenPage".

    //trigger OnOpenPage()
    //begin
    /*

    FilterOnRecord;
    */
    //end;

    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
        SkipFilter: Boolean;
        UserSetup: Record "91";
    begin
        UserSetup.GET(USERID);
        IF ("Document Profile" = "Document Profile"::"Vehicles Trade") THEN
            IF UserSetup."Allow View all Veh. Invoice" THEN
                SkipFilter := TRUE;
        IF NOT SkipFilter THEN BEGIN
            RespCenterFilter := UserMgt.GetSalesFilter();
            IF RespCenterFilter <> '' THEN BEGIN
                Rec.FILTERGROUP(2);
                IF UserMgt.DefaultResponsibility THEN
                    Rec.SETRANGE("Responsibility Center", RespCenterFilter)
                ELSE
                    Rec.SETRANGE("Accountability Center", RespCenterFilter);
                Rec.FILTERGROUP(0);
            END;
        END;
    end;

    procedure SendMailWithAttachment()
    var
        SalesLineRec: Record "39";
        VendorRec: Record "23";
        SMTPMailSetup: Codeunit "400";
        SMTPMailRec: Record "409";
        FileManagement: Codeunit "419";
        UserSetupRec: Record "91";
        TenantID: Code[20];
        DealerInformationRec: Record "33020428";
        FileName: Text;
        RegionalManagerEmail: Text;
        CompInfo: Record "79";
        SalesHeaderRec: Record "36";
    begin
        SalesHeaderRec.RESET;//bikalpa
        SalesHeaderRec.SETRANGE("Document Type", Rec."Document Type"::Order);
        SalesHeaderRec.SETRANGE("No.", Rec."No.");
        IF SalesHeaderRec.FINDFIRST THEN BEGIN
            TenantID := "Dealer Tenant ID";
            IF DealerInformationRec.GET(TenantID) THEN
                RegionalManagerEmail := DealerInformationRec."Regional Manager Email";

            SMTPMailRec.GET;
            FileName := FileManagement.ServerTempFileName('pdf');
            REPORT.SAVEASPDF(50014, FileName, SalesHeaderRec);

            SMTPMailSetup.CreateMessage('', SMTPMailRec."User ID", RegionalManagerEmail, 'Purchase Order', '', TRUE);
            SMTPMailSetup.AddAttachment(FileName, SalesHeaderRec."No." + '.pdf');
            SMTPMailSetup.AppendBody('Dear Sir/Madam');
            SMTPMailSetup.AppendBody('<br><br>');
            SMTPMailSetup.AppendBody('Dealer has forwarded you the following Purchase Order');
            SMTPMailSetup.AppendBody('<br><br>');
            SMTPMailSetup.AppendBody('<HR>');
            SMTPMailSetup.AppendBody('Thank You');

            SMTPMailSetup.Send;
        END;
    end;
}

