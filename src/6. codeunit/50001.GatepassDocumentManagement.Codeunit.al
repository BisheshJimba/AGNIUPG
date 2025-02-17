codeunit 50001 "Gatepass Document Management"
{

    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure createVehTransGatepass(PrmTransHdr: Record "5740")
    var
        LclTransLine: Record "5741";
        LclGatepassHdr: Record "50004";
        LclGatepassLine: Record "50005";
        LclGatePassCard: Page "33020187";
    begin
        LclTransLine.RESET;
        LclTransLine.SETRANGE("Document No.", PrmTransHdr."No.");
        LclTransLine.SETRANGE("Document Profile", PrmTransHdr."Document Profile");
        IF LclTransLine.FIND('-') THEN BEGIN
            REPEAT
                //Code to insert records in Gatepass Header and Lines goes here and open the page.
                LclGatepassHdr.INIT;
                LclGatepassHdr."Document Type" := LclGatepassHdr."Document Type"::Admin;
                LclGatepassHdr.Location := getUserDefaultLocation;
                LclGatepassHdr.VALIDATE("Issued Date", TODAY);
                LclGatepassHdr."Document No" := '';
                LclGatepassHdr.INSERT(TRUE);
                LclGatepassLine.INIT;
                LclGatepassLine."Document Type" := LclGatepassHdr."Document Type";
                LclGatepassLine."Document No." := LclGatepassHdr."Document No";
                LclGatepassLine."Line No." := getLineNo(LclGatepassHdr) + 10000;
                LclGatepassLine."Item Type" := LclGatepassLine."Item Type"::Vehicle;
                LclGatepassLine.VALIDATE("Item No.", LclTransLine."Vehicle Serial No.");
                LclGatepassLine."Item Description" := LclTransLine.Description;
                LclGatepassLine.Quantity := LclTransLine.Quantity;
                LclGatepassLine.INSERT;
            UNTIL LclTransLine.NEXT = 0;
        END;
        COMMIT;
        LclGatePassCard.SETTABLEVIEW(LclGatepassHdr);
        LclGatePassCard.RUNMODAL;
    end;

    [Scope('Internal')]
    procedure createVehServGatepass(ServiceHeader: Record "25006145")
    var
        GatepassHdr: Record "50004";
        GatepassLine: Record "50005";
        ServiceLine: Record "25006146";
    begin
        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE(ServiceLine.Type, ServiceLine.Type::"External Service");
        IF ServiceLine.FIND('-') THEN BEGIN
            GatepassHdr.INIT;
            GatepassHdr."Document Type" := GatepassHdr."Document Type"::"Spare Parts Trade";
            GatepassHdr.Description := 'External Service';
            GatepassHdr.VALIDATE("Issued Date", TODAY);
            GatepassHdr."Document No" := '';
            GatepassHdr."External Document No." := ServiceHeader."No.";
            GatepassHdr.INSERT(TRUE);
            getUserServiceLocation(GatepassHdr);
            GatepassHdr.MODIFY;
            GatepassLine.INIT;
            GatepassLine."Document Type" := GatepassHdr."Document Type";
            GatepassLine."Document No." := GatepassHdr."Document No";
            GatepassLine."Line No." := getLineNo(GatepassHdr) + 10000;
            GatepassLine."Item Type" := GatepassLine."Item Type"::Vehicle;
            GatepassLine."Item Description" := 'External Service';
            GatepassLine.VALIDATE("Item No.", ServiceHeader."Vehicle Serial No.");
            GatepassLine.Quantity := 1;
            GatepassLine.INSERT;
        END;
    end;

    [Scope('Internal')]
    procedure createSparesGatepass()
    begin
    end;

    [Scope('Internal')]
    procedure createProcGatepass()
    begin
    end;

    [Scope('Internal')]
    procedure getUserDefaultLocation(): Code[10]
    var
        LclUserSetup: Record "91";
    begin
        LclUserSetup.GET(USERID);
        EXIT(LclUserSetup."Default Location");
    end;

    [Scope('Internal')]
    procedure getLineNo(PrmGatepassHdr: Record "50004"): Integer
    var
        LclGatepassLine: Record "50005";
    begin
        LclGatepassLine.RESET;
        LclGatepassLine.SETRANGE("Document Type", PrmGatepassHdr."Document Type");
        LclGatepassLine.SETRANGE("Document No.", PrmGatepassHdr."Document No");
        IF LclGatepassLine.FIND('-') THEN
            EXIT(LclGatepassLine."Line No.");
    end;

    [Scope('Internal')]
    procedure getUserServiceLocation(var GatePassHeader: Record "50004")
    var
        UserProfile: Record "25006067";
        ServLocation: Code[20];
        ServSetup: Record "25006120";
        UserProfileMgt: Codeunit "25006002";
        UserSetup: Record "91";
    begin
        IF UserProfileMgt.CurrProfileID <> '' THEN BEGIN
            IF UserProfile.GET(UserProfileMgt.CurrProfileID) THEN BEGIN
                GatePassHeader.Location := UserProfile."Def. Service Location Code";
                IF UserSetup.GET(USERID) THEN
                    GatePassHeader."Responsibility Center" := UserSetup."Service Resp. Ctr. Filter";
            END;
        END;
    end;
}

