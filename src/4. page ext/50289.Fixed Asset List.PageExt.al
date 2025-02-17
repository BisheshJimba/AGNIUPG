pageextension 50289 pageextension50289 extends "Fixed Asset List"
{
    // 13.03.2014 Elva Baltic P7 #S0031 MMG7.00
    //   * Fields added
    //     -FA Posting Group
    //     -Blocked
    //     -Inactive
    //     -Vehicle Serial No.
    //     -VIN
    //     -Make Code
    //     -Model Code
    //   * Function added - GetBookValue
    Editable = false;
    Editable = false;

    //Unsupported feature: Property Insertion (Permissions) on ""Fixed Asset List"(Page 5601)".

    layout
    {
        addafter("Control 2")
        {
            field("Old FA No."; Rec."Old FA No.")
            {
            }
            field("Description 2"; Rec."Description 2")
            {
            }
        }
        addafter("Control 35")
        {
            field("Responsible Employee Name"; "Responsible Employee Name")
            {
            }
        }
        addafter("Control 33")
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
            }
            field("Warranty Expiry Date"; "Warranty Expiry Date")
            {
            }
            field("Insurance Expiry Date"; "Insurance Expiry Date")
            {
            }
        }
        addafter("Control 8")
        {
            field("Depreciation Date"; Rec."Depreciation Date")
            {
            }
            field("Serial No."; Rec."Serial No.")
            {
            }
            field("Disposal Date"; "Disposal Date")
            {
            }
        }
        addafter("Control 12")
        {
            field("FA Posting Group"; Rec."FA Posting Group")
            {
            }
            field("Location Code"; Rec."Location Code")
            {
            }
            field(Blocked; Rec.Blocked)
            {
            }
            field(Inactive; Rec.Inactive)
            {
            }
            field("Vehicle Serial No."; Rec."Vehicle Serial No.")
            {
            }
            field(VIN; Rec.VIN)
            {
            }
            field("Vehicle Registration Number"; "Vehicle Registration Number")
            {
            }
            field("Seat Capacity"; Rec."Seat Capacity")
            {
            }
            field("Make Code"; Rec."Make Code")
            {
            }
            field("Model Code"; Rec."Model Code")
            {
            }
            field("Disposal Invoice No."; "Disposal Invoice No.")
            {
            }
            field(GetBookValue; GetBookValue)
            {
                Caption = 'Book Value';
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 41".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 40".


        //Unsupported feature: Property Modification (RunPageView) on "Action 37".


        //Unsupported feature: Property Modification (RunPageView) on "Action 38".

        addafter("Action 39")
        {
            action("Maintenance Ledg. Entries")
            {
                RunObject = Page 33020089;
                RunPageLink = Document Subclass=FIELD(No.);
                RunPageView = SORTING(Document No.,Document Class,Document Subclass,Posting Date);
            }
        }
        addafter("Action 48")
        {
            action("FA Transfer")
            {
                Image = TransferToGeneralJournal;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page 33019903;
                                RunPageLink = FA No.=FIELD(No.);
                RunPageMode = Create;
            }
            action("FA Transfer History")
            {
                Image = History;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page 33019904;
                                RunPageLink = FA No.=FIELD(No.);
            }
        }
        addafter("Action 1903807106")
        {
            action(GatePass)
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CreateGatePass();
                end;
            }
            action("Fixed Assets Card")
            {
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(FixedAsset);
                    REPORT.RUNMODAL(50049,TRUE,TRUE,FixedAsset);
                end;
            }
            action("QR Print")
            {
                Caption = '&QR Print';
                Image = BarCode;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FARec: Record "5600";
                    FAFilter: Text;
                    STCode: Record "7" temporary;
                    FARec1: Record "5600";
                begin
                    CLEAR(FARec);
                    CurrPage.SETSELECTIONFILTER(FARec);
                    IF FARec.FINDSET THEN REPEAT
                      IF FAFilter = '' THEN
                        FAFilter := FARec."No."
                      ELSE
                        FAFilter +='|'+FARec."No.";
                    UNTIL FARec.NEXT= 0;

                    FARec1.RESET;
                    FARec1.SETFILTER("No.",FAFilter);
                    REPORT.RUN(REPORT::"Fixed Assets QR",TRUE,TRUE,FARec1);
                end;
            }
            action("Register FA Log")
            {
                Caption = 'Register FA Log';
                Image = Register;

                trigger OnAction()
                var
                    RegisterFALOg: Page "33020798";
                begin
                    CLEAR(RegisterFALOg);
                    RegisterFALOg.SetFANo("No.");
                    RegisterFALOg.RUNMODAL;
                end;
            }
            action("FA Log Entries")
            {
                Image = list;
                RunObject = Page 33020799;
                                RunPageView = SORTING(Travel Date)
                              ORDER(Descending);
            }
            action("Update Odometer Ending")
            {

                trigger OnAction()
                var
                    filterPage: FilterPageBuilder;
                    FALogPage: Page "33020799";
                                   FALog: Record "33020799";
                                   FALog1: Record "33020799";
                                   FANo: Code[20];
                                   EmpNo: Code[20];
                                   OdometerEnd: Decimal;
                                   OdoEnding: Text[100];
                                   FixedAsset: Record "5600";
                                   No1: Code[10];
                begin
                    CLEAR(filterPage);
                    CLEAR(FANo);
                    CLEAR(EmpNo);
                    FANo := Rec."No.";//Bishesh Jimba 14Aug24
                    CurrPage.SETSELECTIONFILTER(FixedAsset);//Bishesh Jimba 14Aug24
                    FALog.SETRANGE("Fixed Asset No.",FANo);//Bishesh Jimba 14Aug24
                    filterPage.ADDRECORD('FA Log',FALog);
                    filterPage.ADDFIELD('FA Log',FALog."Fixed Asset No.");//Bishesh Jimba 14Aug24
                    filterPage.ADDFIELD('FA Log', FALog."Odometer Ending");
                    filterPage.RUNMODAL;
                    FALog.SETVIEW(filterPage.GETVIEW('FA Log'));
                    OdoEnding := FALog.GETFILTER("Odometer Ending");
                    EVALUATE(OdometerEnd,OdoEnding);
                    IF OdometerEnd<>0 THEN BEGIN
                       FixedAsset.COPY(Rec);
                       CurrPage.SETSELECTIONFILTER(FixedAsset);
                       FALog1.RESET;
                       FALog1.SETRANGE("Fixed Asset No.", Rec."No.");
                       IF FALog1.FINDLAST THEN BEGIN
                         IF CONFIRM('Do you want to update Odometer Ending of Fixed Asset No. %1?', TRUE,Rec."No.") THEN BEGIN//Bishesh Jimba 14Aug24
                           FALog1."Odometer Ending" := OdometerEnd;
                           FALog1."Total Trip Distance" := FALog1."Odometer Ending" - FALog1."Odometer Opening";
                           FALog1.MODIFY;
                           MESSAGE('Odometer reading updated.');
                          END;
                       END;
                    END;
                end;
            }
        }
    }

    var
        FixedAsset: Record "5600";
        StplMgt: Codeunit "50000";

    procedure GetBookValue(): Decimal
    var
        FADepreciationBook: Record "5612";
        FALedgerEntry: Record "5601";
        Value: Decimal;
    begin
        Value := 0;
        FADepreciationBook.RESET;
        FADepreciationBook.SETRANGE("FA No.", "No.");
        IF NOT FADepreciationBook.FIND('-') THEN
          EXIT(0);
        //FADepreciationBook.CALCFIELDS("Book Value");
        FALedgerEntry.RESET;
        FALedgerEntry.SETCURRENTKEY("FA No.", "Depreciation Book Code");
        FALedgerEntry.SETRANGE("FA No.", "No.");
        FALedgerEntry.SETRANGE("Depreciation Book Code", FADepreciationBook."Depreciation Book Code");
        FALedgerEntry.SETFILTER("FA Posting Type", '%1|%2|%3|%4',FALedgerEntry."FA Posting Type"::"Acquisition Cost",
                             FALedgerEntry."FA Posting Type"::Depreciation,
                             FALedgerEntry."FA Posting Type"::"Write-Down", FALedgerEntry."FA Posting Type"::Appreciation);
        IF FALedgerEntry.FIND('-') THEN
          REPEAT
            Value += FALedgerEntry.Amount;
          UNTIL FALedgerEntry.NEXT = 0;
        EXIT(Value);
    end;

    procedure CreateGatePass()
    var
        GatepassHeader: Record "50004";
        GatepassLine: Record "50005";
        GatepassPage: Page "50002";
                          Text000: Label 'Document cannot be identified for gatepass. Please issue Gatepass Manually.';
        ServHdrEDMS: Record "25006145";
    begin
        GatepassHeader.RESET;
        GatepassHeader.SETCURRENTKEY("External Document No.");
        GatepassHeader.SETRANGE("External Document No.","No.");
        GatepassHeader.SETRANGE("External Document Type",GatepassHeader."External Document Type"::Repair);
        IF NOT GatepassHeader.FINDFIRST THEN
        BEGIN
          GatepassHeader.INIT;
          GatepassHeader."Document Type" := GatepassHeader."Document Type"::Admin;
          GatepassHeader."External Document Type" := GatepassHeader."External Document Type"::Repair;
          GatepassHeader."External Document No.":= "No.";
          ServHdrEDMS.RESET;
          ServHdrEDMS.SETRANGE("No.","No.");
          IF ServHdrEDMS.FINDFIRST THEN BEGIN
            GatepassHeader."Vehicle Registration No." := ServHdrEDMS."Vehicle Registration No.";
            GatepassHeader.Kilometer := ServHdrEDMS.Kilometrage;
          END;
          GatepassHeader.Destination := 'Out';
          GatepassHeader.VALIDATE("Issued Date",TODAY);
          GatepassHeader.Description := Description + ' ' +"Description 2";
          GatepassHeader.INSERT(TRUE);
        END;
        GatepassPage.SETRECORD(GatepassHeader);
        GatepassPage.RUN;
    end;
}

