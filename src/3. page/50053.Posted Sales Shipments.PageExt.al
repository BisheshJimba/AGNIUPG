pageextension 50053 pageextension50053 extends "Posted Sales Shipments"
{

    //Unsupported feature: Property Modification (SourceTableView) on ""Posted Sales Shipments"(Page 142)".

    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 33".


        //Unsupported feature: Property Modification (RunPageLink) on "CertificateOfSupplyDetails(Action 3)".


        //Unsupported feature: Code Modification on "Action 21.OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CurrPage.SETSELECTIONFILTER(SalesShptHeader);
        SalesShptHeader.PrintRecords(TRUE);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        CurrPage.SETSELECTIONFILTER(SalesShptHeader);
        SalesShptHeader.PrintRecords2(TRUE);
        */
        //end;
        addafter("Action 22")
        {
            action("<Action1000000000>")
            {
                Caption = 'GatePass';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    CreateGatePass;
                end;
            }
        }
    }

    var
        SalesShptHeader: Record "110";


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetSecurityFilterOnRespCenter;
    IF FINDFIRST THEN;
    IsOfficeAddin := OfficeMgt.IsAvailable;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //SetSecurityFilterOnRespCenter;
    IF FINDFIRST THEN;
    IsOfficeAddin := OfficeMgt.IsAvailable;

    FilterOnRecord;
    */
    //end;

    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
    begin
        RespCenterFilter := UserMgt.GetSalesFilter();
        IF RespCenterFilter <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            IF UserMgt.DefaultResponsibility THEN
                Rec.SETRANGE("Responsibility Center", RespCenterFilter)
            ELSE
                Rec.SETRANGE("Accountability Center", RespCenterFilter);
            Rec.FILTERGROUP(0);
        END;
    end;

    procedure CreateGatePass()
    var
        GatepassHeader: Record "50004";
        GatepassLine: Record "50005";
        GatepassPage: Page "50002";
        Text000: Label 'Document cannot be identified for gatepass. Please issue Gatepass Manually.';
        LineNo: Integer;
        SalesShipLine: Record "111";
    begin
        GatepassHeader.RESET;
        GatepassHeader.SETCURRENTKEY("External Document No.");
        GatepassHeader.SETRANGE("External Document No.", Rec."No.");
        IF NOT GatepassHeader.FINDFIRST THEN BEGIN
            GatepassHeader.INIT;
            IF Rec."Document Profile" = Rec."Document Profile"::Service THEN
                GatepassHeader."Document Type" := GatepassHeader."Document Type"::"Vehicle Service"
            ELSE
                IF Rec."Document Profile" = Rec."Document Profile"::"Spare Parts Trade" THEN
                    GatepassHeader."Document Type" := GatepassHeader."Document Type"::"Spare Parts Trade"
                ELSE
                    IF Rec."Document Profile" = Rec."Document Profile"::"Vehicles Trade" THEN
                        GatepassHeader."Document Type" := GatepassHeader."Document Type"::"Vehicle Trade"
                    ELSE
                        IF Rec."Document Profile" = Rec."Document Profile"::" " THEN
                            GatepassHeader."Document Type" := GatepassHeader."Document Type"::Admin;
            GatepassHeader."External Document Type" := GatepassHeader."External Document Type"::"Transfer Order";
            GatepassHeader."External Document No." := Rec."No.";
            GatepassHeader."Ship Address" := Rec."Ship-to Address";
            GatepassHeader.VALIDATE("Issued Date", TODAY);
            GatepassHeader.Destination := 'OUT';
            GatepassHeader.INSERT(TRUE);
        END;

        SalesShipLine.RESET;
        SalesShipLine.SETRANGE("Document No.", Rec."No.");
        IF SalesShipLine.FINDSET THEN
            REPEAT
                GatepassLine.RESET;
                GatepassLine.SETRANGE("Document No.", GatepassHeader."Document No");
                GatepassLine.SETRANGE("Ext Document No.", Rec."No.");
                GatepassLine.SETRANGE("Item No.", SalesShipLine."No.");
                IF NOT GatepassLine.FINDFIRST THEN BEGIN
                    LineNo := 0;
                    GatepassLine.RESET;
                    IF GatepassLine.FINDLAST THEN
                        LineNo := GatepassLine."Line No." + 1;
                    CLEAR(GatepassLine);
                    GatepassLine.INIT;
                    GatepassLine."Line No." := LineNo;
                    IF Rec."Document Profile" = Rec."Document Profile"::Service THEN
                        GatepassLine."Document Type" := GatepassLine."Document Type"::"Vehicle Service"
                    ELSE
                        IF Rec."Document Profile" = Rec."Document Profile"::"Spare Parts Trade" THEN BEGIN
                            GatepassLine."Document Type" := GatepassLine."Document Type"::"Spare Parts Trade";
                            GatepassLine."Item Type" := GatepassLine."Item Type"::Spares;
                            GatepassLine.VALIDATE("Item No.", SalesShipLine."No.");
                        END
                        ELSE
                            IF Rec."Document Profile" = Rec."Document Profile"::"Vehicles Trade" THEN BEGIN
                                GatepassLine."Document Type" := GatepassLine."Document Type"::"Vehicle Trade";
                                GatepassLine."Item Type" := GatepassLine."Item Type"::Vehicle;
                                GatepassLine.VALIDATE("Item No.", SalesShipLine."Vehicle Serial No.");
                            END
                            ELSE
                                IF Rec."Document Profile" = Rec."Document Profile"::" " THEN
                                    GatepassLine."Document Type" := GatepassLine."Document Type"::Admin;
                    GatepassLine."Document No." := GatepassHeader."Document No";
                    GatepassLine.Quantity := SalesShipLine.Quantity;
                    GatepassLine."Ext Document No." := GatepassHeader."External Document No.";
                    GatepassLine.INSERT(TRUE);

                END;
            UNTIL SalesShipLine.NEXT = 0;
        GatepassPage.SETRECORD(GatepassHeader);
        GatepassPage.RUN;
    end;
}

