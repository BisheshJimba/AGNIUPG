page 33019894 "Recharged Job Card"
{
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Print';
    RefreshOnActivate = true;
    SourceTable = Table33019894;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Job Card No."; "Job Card No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Battery Serial No."; "Battery Serial No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Customer Address"; "Customer Address")
                {
                }
                field("Sales Date"; "Sales Date")
                {

                    trigger OnValidate()
                    begin
                        /*
                        //Code to break sales date into year,month,day
                        GblSalesYear := DATE2DMY("Sales Date",3);
                        GblSalesMonth := DATE2DMY("Sales Date",2);
                        GblSalesDay := DATE2DMY("Sales Date",1);
                        
                        //Code to break current date into year,month,day
                        GblCurYear := DATE2DMY(TODAY,3);
                        GblCurMonth := DATE2DMY(TODAY,2);
                        GblCurDay := DATE2DMY(TODAY,1);
                        
                        GblDiffYear := GblCurYear - GblSalesYear;
                        GblDiffMonth := ABS(GblCurMonth - GblSalesMonth);
                        GblDiffDay := ABS(GblCurDay - GblSalesDay);
                        
                        //GblTotalMonth := (GblDiffYear * 12) + GblDiffMonth + (GblCurDay / 30);
                        
                        //MESSAGE('%1',GblTotalMonth);
                        
                        GblDate1 := TODAY;
                        GblDate2 := 140212D;
                        Days := ROUND(GblDate2-GblDate1);
                        Years := ROUND(Days/365);
                        MESSAGE('Date 1 %1\Date 2 %2\Days %3\Years %4',GblDate1,GblDate2,Days,Years);
                        
                        */

                        /*
                        IF "Sales Date" <> 0D THEN
                          Age := (TODAY) - ("Sales Date");
                          Age := (Age / 30);
                          //Age := ROUND(Age,1);
                        
                        MESSAGE('%1',Age);
                         */
                        /*
                       //Months := ROUND((TODAY -  "Sales Date") / 30,0.01);
                       Months := (TODAY -  "Sales Date") DIV 30;

                       IF ((TODAY -  "Sales Date") MOD 30) > 15 THEN
                          Months := Months + 1;

                       MESSAGE('%1',Months);
                       */
                        /*
                        Months := ROUND((TODAY -  "Sales Date") / 30,0.01);
                        Month := Months;
                        MESSAGE('%1',Months);
                        */

                    end;
                }
                field("Sales Date (BS)"; "Sales Date (BS)")
                {
                }
                field("Warranty Date"; "Warranty Date")
                {
                    Visible = false;
                }
                field(Month; Month)
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Job Start Date"; "Job Start Date")
                {
                }
                field("Promise Date"; "Promise Date")
                {
                }
                field("Job End Date"; "Job End Date")
                {
                }
                field("Customer Agent No."; "Customer Agent No.")
                {
                    Caption = 'Dealer No.';
                }
                field("Customer Agent Name"; "Customer Agent Name")
                {
                    Caption = 'Dealer Name';
                }
                field("Dealer Address"; "Dealer Address")
                {
                    Caption = 'Dealer Address';
                }
            }
            group("Battery Reference")
            {
                field("Battery Part No."; "Battery Part No.")
                {
                }
                field("Battery Description"; "Battery Description")
                {
                    Editable = false;
                }
                field("Battery Type"; "Battery Type")
                {
                    Editable = false;
                }
                field(MFG; MFG)
                {
                }
                field("Vehicle Model"; "Vehicle Model")
                {
                }
                field("Vehicle Type"; "Vehicle Type")
                {
                }
                field(Registration; Registration)
                {
                }
                field("OE/Trd"; "OE/Trd")
                {

                    trigger OnValidate()
                    begin
                        /*
                       IF ("OE/Trd" = "OE/Trd"::PW) OR ("OE/Trd" = "OE/Trd"::MW)  THEN
                         ShowMe := TRUE
                       ELSE
                         ShowMe := FALSE;
                        */

                    end;
                }
                field("Prorata Percent"; "Prorata Percent")
                {
                    Caption = 'Prorata Percentage';
                    Visible = false;
                }
                field("KM."; "KM.")
                {
                }
                field("Serv Batt Type"; "Serv Batt Type")
                {
                    Caption = 'Service Battery';
                }
                field("Service Batt No."; "Service Batt No.")
                {
                }
                field("Gua.Card"; "Gua.Card")
                {
                }
                field("Replaced Part"; "Replaced Part")
                {
                    Caption = 'Replaced Part No.';
                    Editable = ReplacedPart;

                    trigger OnValidate()
                    begin
                        IF "Replaced Part" = '' THEN
                            ExideClaim := FALSE
                        ELSE
                            ExideClaim := TRUE;
                    end;
                }
                field("Rep. Batt. MFG"; "Rep. Batt. MFG")
                {
                    Caption = 'Rep. Batt. MFG Code';
                    Editable = ReplacedMFG;
                }
                field("Rep. Batt. Serial"; "Rep. Batt. Serial")
                {
                    Caption = 'Rep. Batt. Serial No.';
                    Editable = ReplacedSerial;
                }
                field(Remarks; Remarks)
                {
                    MultiLine = true;
                }
            }
            part("Cell Nos. +ve End"; 33019919)
            {
                Caption = 'Cell Nos. +ve End';
                SubPageLink = Job Card No.=FIELD(Job Card No.);
            }
            group("Actions")
            {
                Caption = 'Actions';
                field(Action; Action)
                {
                    Caption = 'Action To Be Taken';

                    trigger OnValidate()
                    begin
                        // to have gate pass on recharge or reject action
                        IF (Action = Action::Recharge) OR (Action = Action::Reject) THEN
                            GatePass := TRUE
                        ELSE
                            GatePass := FALSE;

                        //
                        IF Action = Action::Replace THEN BEGIN
                            ExideClaim := TRUE;
                            ReplacedPart := TRUE;
                            ReplacedMFG := TRUE;
                            ReplacedSerial := TRUE;
                        END
                        ELSE BEGIN
                            ExideClaim := FALSE;
                            ReplacedPart := FALSE;
                            ReplacedMFG := FALSE;
                            ReplacedSerial := FALSE;
                            "Replaced Part" := '';
                            "Rep. Batt. Serial" := '';
                            "Rep. Batt. MFG" := '';
                        END
                    end;
                }
                field("Bill to Agent"; "Bill to Agent")
                {
                    Visible = false;
                }
            }
            group("Job Details")
            {
                field("Claim No."; "Claim No.")
                {
                }
                field("Issue No."; "Issue No.")
                {
                }
                field(Bill; Bill)
                {
                }
                field(GRN; GRN)
                {
                }
                field("Warranty Percentage"; "Warranty Percentage")
                {
                    Editable = false;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Job Closed"; "Job Closed")
                {
                }
                field(Date; Date)
                {
                }
            }
            group(Others)
            {
                field("Internal Comment"; "Internal Comment")
                {
                    MultiLine = true;
                }
                field("Job For"; "Job For")
                {
                    Caption = 'Location';
                    Editable = false;
                }
                field("Transfer Ref."; "Transfer Ref.")
                {
                }
                field("Cut Piece Received"; "Cut Piece Received")
                {
                    Caption = 'Cut and Document';
                }
                field("Created By"; "Created By")
                {
                    Editable = false;
                }
                field("Updated By"; "Updated By")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1102159056>")
            {
                Caption = 'Print';
                Image = Print;
                action("<Action1102159057>")
                {
                    Caption = 'Job Card';
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Codeunit 33019887;
                    ShortCutKey = 'F10';

                    trigger OnAction()
                    begin
                        // Message('err');
                    end;
                }
                action("Gate Pass")
                {
                    Caption = 'Gate Pass';
                    Image = Travel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortCutKey = 'F11';

                    trigger OnAction()
                    begin
                        //Message('err');
                        /*
                        GblJobCardEntry.SETRANGE("Job Card No.","Job Card No.");
                        IF GblJobCardEntry.FINDFIRST THEN
                           REPORT.RUNMODAL(33019886,TRUE,FALSE,GblJobCardEntry);
                        
                        BatteryMaster.SETRANGE("Job Card No.","Job Card No.");
                        IF BatteryMaster.FINDFIRST THEN
                           REPORT.RUNMODAL(33019892,TRUE,FALSE,BatteryMaster);
                        */
                        CurrPage.SETSELECTIONFILTER(BatteryMaster);
                        REPORT.RUNMODAL(33019892, TRUE, FALSE, BatteryMaster);
                        REPORT.RUNMODAL(33019894, TRUE, FALSE, BatteryMaster);

                    end;
                }
            }
            group("<Action1102159060>")
            {
                Caption = 'Open';
                action("Exide Claim")
                {
                    Caption = 'Exide Claim';
                    Image = Confirm;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 33019889;
                    RunPageLink = Job Card No.=FIELD(Job Card No.);
                    RunPageMode = Create;
                    Visible = false;

                    trigger OnAction()
                    begin
                        /*
                         GblJobCardEntry.GET("Job Card No.") ;
                         MyRecord."Job Card No." := GblJobCardEntry."Job Card No.";
                         MyRecord."Job Date" := GblJobCardEntry."Job Start Date";
                        */

                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF "Replaced Part" = '' THEN
          ExideClaim := FALSE
        ELSE
          ExideClaim := TRUE;

        IF Recharged = TRUE THEN
          GatePass := TRUE
        ELSE
          GatePass := FALSE;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        UserSetup.GET(USERID);
        IF NOT UserSetup."Battery-Can Edit Pages"  THEN
           ERROR(text0002);
    end;

    var
        [InDataSet]
        ShowMe: Boolean;
        GblSalesYear: Integer;
        GblSalesMonth: Integer;
        GblSalesDay: Integer;
        GblCurYear: Integer;
        GblCurMonth: Integer;
        GblCurDay: Integer;
        GblDiffYear: Integer;
        GblDiffMonth: Integer;
        GblDiffDay: Integer;
        GblJobCardEntry: Record "33019884";
        GblTotalMonth: Decimal;
        GblDate1: Date;
        GblDate2: Date;
        Days: Integer;
        Years: Integer;
        Age: Decimal;
        Months: Decimal;
        [InDataSet]
        GatePass: Boolean;
        [InDataSet]
        ExideClaim: Boolean;
        MyRecord: Record "33019886";
        [InDataSet]
        ReplacedPart: Boolean;
        [InDataSet]
        ReplacedMFG: Boolean;
        [InDataSet]
        ReplacedSerial: Boolean;
        BatteryMaster: Record "33019894";
        UserSetup: Record "91";
        text0002: Label 'You do not have permission to edit this page.';
}

