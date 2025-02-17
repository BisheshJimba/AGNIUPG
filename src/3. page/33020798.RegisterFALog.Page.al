page 33020798 "Register FA Log"
{
    PageType = Card;
    Permissions = TableData 33020799 = rimd;

    layout
    {
        area(content)
        {
            field("FA No."; FANo_)
            {
                Editable = IsEditable;
                TableRelation = "Fixed Asset";
            }
            field("Employee No."; EmployeeNo)
            {
                Editable = IsEditable;
                TableRelation = Employee;
            }
            field("Travel Date"; TravelDate)
            {
                Editable = IsEditable;
            }
            field("Travel Time"; TravelTime)
            {
                Editable = IsEditable;
            }
            field("Gate Pass No."; GatePassNo)
            {
                Editable = IsEditable;
                TableRelation = "Gatepass Header"."Document No";
            }
            field("Odometer Opening"; OdometerOpening)
            {
                Editable = IsEditable;
            }
            field("Travel Type"; TravelType)
            {
                Editable = IsEditable;
            }
            field("From Destination"; FromDes)
            {
                Editable = IsEditable;
            }
            field("To Destination"; ToDes)
            {
                Editable = IsEditable;
            }
            field(Purpose; Purpose)
            {
                Editable = IsEditable;
            }
            field("Driver Name"; DriverName)
            {
                Editable = IsEditable;
            }
            field("Total Trip Distance"; TotalTripDis)
            {
                Editable = IsEditable;
            }
            field("Fuel Quantity"; FuelQuantity)
            {
                Editable = IsEditable;
            }
            field("Memo No."; MemoNo)
            {
                Editable = IsEditable;
            }
            field("Maintainance Cost"; MaintainanceCost)
            {
                Editable = IsEditable;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(GatePass)
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    STPLMgt: Codeunit "50000";
                    Employee: Record "5200";
                begin
                    //CreateGatePass;
                    CheckFAforGatePass;
                    IsEditable := FALSE;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF Usersetup.GET(USERID) THEN
            EnteredBy := Usersetup."User ID";
        IsEditable := TRUE;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction = ACTION::OK THEN
            YesOnPush;
    end;

    var
        Purpose: Text[250];
        Usersetup: Record "91";
        EnteredBy: Code[70];
        TravelDate: Date;
        EmployeeNo: Code[20];
        TravelTime: Time;
        OdometerOpening: Decimal;
        TravelType: Option " ",Business,Personal,Office;
        FromDes: Text[70];
        ToDes: Text[70];
        DriverName: Text[70];
        TotalTripDis: Decimal;
        FuelQuantity: Decimal;
        MemoNo: Code[20];
        MaintainanceCost: Decimal;
        GatePassNo: Code[20];
        STPlMgt: Codeunit "50000";
        FANo_: Code[20];
        IsEditable: Boolean;
        GatepassHeader: Record "50004";

    local procedure YesOnPush()
    begin
        IF CONFIRM('Do you want To register FA Log?', TRUE) THEN
            STPlMgt.CreateFALogEntry(FANo_, TravelDate, EmployeeNo, TravelTime, OdometerOpening, TravelType, FromDes, ToDes, DriverName, TotalTripDis, FuelQuantity, MemoNo, MaintainanceCost, GatePassNo, Purpose);
    end;

    [Scope('Internal')]
    procedure SetFANo(FANo: Code[20])
    begin
        FANo_ := FANo;
    end;

    [Scope('Internal')]
    procedure CreateGatePass()
    var
        GatepassHeader: Record "50004";
        GatepassLine: Record "50005";
        GatepassPage: Page "50002";
        Text000: Label 'Document cannot be identified for gatepass. Please issue Gatepass Manually.';
        Employee: Record "5200";
        FixedAsset: Record "5600";
        Vehicle: Record "25006005";
        FALogEntries: Record "33020799";
    begin
        GatepassHeader.RESET;
        GatepassHeader.SETCURRENTKEY("External Document No.");
        GatepassHeader.SETRANGE("External Document No.", FANo_);
        GatepassHeader.SETRANGE("External Document Type", GatepassHeader."External Document Type"::"FA Transfer");
        IF NOT GatepassHeader.FINDFIRST THEN BEGIN
            GatepassHeader.INIT;
            GatepassHeader."Document Type" := GatepassHeader."Document Type"::Admin;
            GatepassHeader."External Document Type" := GatepassHeader."External Document Type"::" ";
            GatepassHeader."External Document No." := FANo_;
            GatepassHeader."Driver Name" := DriverName;//Bishesh Jimba 20Aug24
            IF Employee.GET(EmployeeNo) THEN;
            GatepassHeader.Person := Employee."Full Name";
            GatepassHeader.Kilometer := OdometerOpening;
            GatepassHeader.Destination := ToDes;
            GatepassHeader.Remarks := Purpose;
            IF FixedAsset.GET(FANo_) THEN BEGIN
                GatepassHeader.Description := FixedAsset.Description + ' ' + FixedAsset."Description 2";
                GatepassHeader.VIN := FixedAsset."VIN No.";//Bishesh Jimba 21aug24
                GatepassHeader."Vehicle Registration No." := FixedAsset."Vehicle Registration Number";//Bishesh Jimba 21aug24
                                                                                                      //    Vehicle.RESET;
                                                                                                      //    Vehicle.SETRANGE(VIN, GatepassHeader.VIN);
                                                                                                      //    IF Vehicle.FINDFIRST THEN
                                                                                                      //      GatepassHeader."Vehicle Registration No." := Vehicle."Registration No.";
            END;
            GatepassHeader.VALIDATE("Issued Date", TODAY);
            GatepassHeader.INSERT(TRUE);
        END;
        GatepassPage.SETRECORD(GatepassHeader);
        GatepassPage.RUN;
        GatePassNo := GatepassHeader."Document No";
    end;

    [Scope('Internal')]
    procedure CheckFAforGatePass()
    var
        GatepassHeader: Record "50004";
        GatepassLine: Record "50005";
        GatepassPage: Page "50002";
        Employee: Record "5200";
        FixedAsset: Record "5600";
        Vehicle: Record "25006005";
        FALogEntries: Record "33020799";
    begin
        FALogEntries.RESET;
        FALogEntries.SETRANGE("Fixed Asset No.", FANo_);
        IF FALogEntries.FINDLAST THEN
            IF FALogEntries."Odometer Ending" <> 0 THEN BEGIN
                GatepassHeader.INIT;
                GatepassHeader."Document Type" := GatepassHeader."Document Type"::Admin;
                GatepassHeader."External Document Type" := GatepassHeader."External Document Type"::"FA Transfer";
                GatepassHeader."External Document No." := FANo_;
                GatepassHeader."Driver Name" := DriverName; // Bishesh Jimba 20Aug24

                IF Employee.GET(EmployeeNo) THEN
                    GatepassHeader.Person := Employee."Full Name";

                GatepassHeader.Kilometer := OdometerOpening;
                GatepassHeader.Destination := ToDes;
                GatepassHeader.Remarks := Purpose;

                IF FixedAsset.GET(FANo_) THEN BEGIN
                    GatepassHeader.Description := FixedAsset.Description + ' ' + FixedAsset."Description 2";
                    GatepassHeader.VIN := FixedAsset."VIN No."; // Bishesh Jimba 21aug24
                    GatepassHeader."Vehicle Registration No." := FixedAsset."Vehicle Registration Number"; // Bishesh Jimba 21aug24
                END;

                GatepassHeader.VALIDATE("Issued Date", TODAY);
                GatepassHeader.INSERT(TRUE);
            END ELSE BEGIN
                GatepassHeader.RESET;
                GatepassHeader.SETCURRENTKEY("External Document No.");
                GatepassHeader.SETRANGE("External Document No.", FANo_);
                GatepassHeader.SETRANGE("External Document Type", GatepassHeader."External Document Type"::"FA Transfer");
                IF NOT GatepassHeader.FINDFIRST THEN BEGIN
                    GatepassHeader.INIT;
                    GatepassHeader."Document Type" := GatepassHeader."Document Type"::Admin;
                    GatepassHeader."External Document Type" := GatepassHeader."External Document Type"::"FA Transfer";
                    GatepassHeader."External Document No." := FANo_;
                    GatepassHeader."Driver Name" := DriverName; // Bishesh Jimba 20Aug24

                    IF Employee.GET(EmployeeNo) THEN
                        GatepassHeader.Person := Employee."Full Name";

                    GatepassHeader.Kilometer := OdometerOpening;
                    GatepassHeader.Destination := ToDes;
                    GatepassHeader.Remarks := Purpose;

                    IF FixedAsset.GET(FANo_) THEN BEGIN
                        GatepassHeader.Description := FixedAsset.Description + ' ' + FixedAsset."Description 2";
                        GatepassHeader.VIN := FixedAsset."VIN No."; // Bishesh Jimba 21aug24
                        GatepassHeader."Vehicle Registration No." := FixedAsset."Vehicle Registration Number"; // Bishesh Jimba 21aug24
                    END;

                    GatepassHeader.VALIDATE("Issued Date", TODAY);
                    GatepassHeader.INSERT(TRUE);
                END;
            END;
        GatepassPage.SETRECORD(GatepassHeader);
        GatepassPage.RUN;
        GatePassNo := GatepassHeader."Document No";
    end;
}

