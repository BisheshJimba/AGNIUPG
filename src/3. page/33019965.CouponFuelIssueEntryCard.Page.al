page 33019965 "Coupon-Fuel Issue Entry Card"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Posting';
    RefreshOnActivate = true;
    SourceTable = Table33019963;
    SourceTableView = WHERE(Document Type=CONST(Coupon));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Location; Location)
                {
                }
                field("Issue Type"; "Issue Type")
                {

                    trigger OnValidate()
                    begin
                        ShowHidePageTabs;
                        "Unit of Measure" := 'LTR';
                    end;
                }
                field("Issue Date"; "Issue Date")
                {
                }
                field("Issue Date (BS)"; "Issue Date (BS)")
                {
                }
                field("Add Additional City"; "Add Additional City")
                {

                    trigger OnValidate()
                    begin
                        ShowHidePageTabs;
                    end;
                }
            }
            group(StaffInfo)
            {
                Caption = 'Staff';
                Visible = GblShowStaff;
                field("Staff No."; "Staff No.")
                {
                }
                field("Staff Name"; "Staff Name")
                {
                }
                field("Issued For"; "Issued For")
                {

                    trigger OnValidate()
                    begin
                        ShowAddInfo;
                    end;
                }
                field(Manufacturer; Manufacturer)
                {
                }
                field("Movement Type"; "Movement Type")
                {

                    trigger OnValidate()
                    begin
                        IF ("Movement Type" = "Movement Type"::Repair) OR ("Movement Type" = "Movement Type"::Delivery) OR
                           ("Movement Type" = "Movement Type"::Demo) OR ("Movement Type" = "Movement Type"::Transfer) THEN BEGIN
                            MESSAGE('This Movement Type is not applicable!');
                            "Movement Type" := "Movement Type"::" ";
                        END
                    end;
                }
                field("VIN (Chasis No.)"; "VIN (Chasis No.)")
                {
                    Caption = 'Chasis No. (VIN)';
                }
                field("Registration No."; "Registration No.")
                {
                    Caption = 'Registration No.';
                }
                field(Mileage; Mileage)
                {

                    trigger OnValidate()
                    begin
                        CalculateDiffkm;
                        "Issued Fuel (Litre)" := ROUND((GblDiffKM / Mileage), 1, '>');
                        "Amount (Rs.)" := (("Issued Fuel (Litre)" + "Issued Fuel Add. (Litre)") * "Rate (Rs.)");
                    end;
                }
                field("Kilometerage (KM)"; "Kilometerage (KM)")
                {

                    trigger OnValidate()
                    begin
                        CalculateDiffkm;
                        VALIDATE("Issued Fuel (Litre)", ROUND((GblDiffKM / Mileage), 1, '>'));
                        "Amount (Rs.)" := (("Issued Fuel (Litre)" + "Issued Fuel Add. (Litre)") * "Rate (Rs.)");
                    end;
                }
                field(GblDiffKM; GblDiffKM)
                {
                    Caption = 'Difference KM';
                    Editable = false;
                }
                field("Issued To"; "Issued To")
                {
                }
            }
            group(Department)
            {
                Visible = GblShowDept;
                field("<Department >"; Department)
                {

                    trigger OnValidate()
                    begin
                        IF Department <> '' THEN
                            GblDname := FALSE
                        ELSE
                            GblDname := TRUE
                    end;
                }
                field("Department Name"; "Department Name")
                {
                    Editable = GblDname;
                }
                field("<Issued For >"; "Issued For")
                {

                    trigger OnValidate()
                    begin
                        ShowAddInfo;
                    end;
                }
                field("<Manufacturer >"; Manufacturer)
                {
                }
                field("<Movement Type >"; "Movement Type")
                {

                    trigger OnValidate()
                    begin
                        IF ("Movement Type" = "Movement Type"::Regular) OR ("Movement Type" = "Movement Type"::Delivery) OR
                           ("Movement Type" = "Movement Type"::Demo) OR ("Movement Type" = "Movement Type"::Transfer) THEN BEGIN
                            MESSAGE('This Movement Type is not applicable!');
                            "Movement Type" := "Movement Type"::" ";
                        END
                    end;
                }
                field("<VIN (Chasis No.) >"; "VIN (Chasis No.)")
                {
                    Caption = 'Chasis No. (VIN)';
                }
                field("<Registration No. >"; "Registration No.")
                {
                    Caption = 'Registration No.';
                }
                field("<Mileage >"; Mileage)
                {

                    trigger OnValidate()
                    begin
                        CalculateDiffkm;
                        "Issued Fuel (Litre)" := ROUND((GblDiffKM / Mileage), 1, '>');
                        "Amount (Rs.)" := (("Issued Fuel (Litre)" + "Issued Fuel Add. (Litre)") * "Rate (Rs.)");
                    end;
                }
                field("<Kilometerage (KM) >"; "Kilometerage (KM)")
                {

                    trigger OnValidate()
                    begin
                        CalculateDiffkm;
                        VALIDATE("Issued Fuel (Litre)", ROUND((GblDiffKM / Mileage), 1, '>'));
                        "Amount (Rs.)" := (("Issued Fuel (Litre)" + "Issued Fuel Add. (Litre)") * "Rate (Rs.)");
                    end;
                }
                field("Difference KM "; GblDiffKM)
                {
                    Caption = 'Difference KM';
                    Editable = false;
                }
                field("<Issued To >"; "Issued To")
                {
                }
            }
            group(SalesInfo)
            {
                Caption = 'Sales';
                Visible = GblShowSales;
                field("<Issued For>"; "Issued For")
                {

                    trigger OnValidate()
                    begin
                        ShowAddInfo;
                    end;
                }
                field("<Manufacturer>"; Manufacturer)
                {
                }
                field("Movement Type "; "Movement Type")
                {

                    trigger OnValidate()
                    begin
                        IF ("Movement Type" = "Movement Type"::Repair) OR ("Movement Type" = "Movement Type"::Regular) OR
                           ("Movement Type" = "Movement Type"::"Office Use") OR ("Movement Type" = "Movement Type"::Others) THEN BEGIN
                            MESSAGE('This Movement Type is not applicable!');
                            "Movement Type" := "Movement Type"::" ";
                        END
                    end;
                }
                field("VIN (Chasis No.) "; "VIN (Chasis No.)")
                {
                    Caption = 'Chasis No. (VIN)';
                }
                field("Registration No. "; "Registration No.")
                {
                    Caption = 'Registration No.';
                }
                field("Mileage "; Mileage)
                {

                    trigger OnValidate()
                    begin
                        "Issued Fuel (Litre)" := ROUND((GblDiffKM / Mileage), 1, '>');
                        "Amount (Rs.)" := (("Issued Fuel (Litre)" + "Issued Fuel Add. (Litre)") * "Rate (Rs.)");
                    end;
                }
                field("Kilometerage (KM) "; "Kilometerage (KM)")
                {
                }
                field("Issued To 1 "; "Issued To")
                {
                }
            }
            group(Others)
            {
                Caption = 'Others';
                Visible = GblShowOther;
                field("Issued For  "; "Issued For")
                {

                    trigger OnValidate()
                    begin
                        ShowAddInfo;
                    end;
                }
                field("Manufacturer "; Manufacturer)
                {
                }
                field("Kilometerage (KM) 1"; "Kilometerage (KM)")
                {
                    Caption = 'Kilometerage (KM) 1';
                }
                field("Issued To 1"; "Issued To")
                {
                }
            }
            group(CouponInfo)
            {
                Caption = 'Coupon Information';
                Visible = GblShowCoupon;
                field("From City Code"; "From City Code")
                {
                }
                field("From City Name"; "From City Name")
                {
                }
                field("To City Code"; "To City Code")
                {

                    trigger OnValidate()
                    begin
                        IF "Add Additional City" = TRUE THEN BEGIN
                            "Add. From City Code" := "To City Code";
                            "Add. From City Name" := "To City Name";
                        END;
                    end;
                }
                field("To City Name"; "To City Name")
                {

                    trigger OnValidate()
                    begin
                        //IF "Add Additional City" = TRUE THEN
                        // "Add. From City Name" := "To City Name";
                    end;
                }
                field(Distance; Distance)
                {
                }
                field("Issued Fuel (Litre)"; "Issued Fuel (Litre)")
                {

                    trigger OnValidate()
                    begin
                        "Amount (Rs.)" := (("Issued Fuel (Litre)" + "Issued Fuel Add. (Litre)") * "Rate (Rs.)");
                        //"Total Fuel Issued" := "Issued Fuel (Litre)" + "Issued Fuel Add. (Litre)" ;
                    end;
                }
                field("Issued Fuel Add. (Litre)"; "Issued Fuel Add. (Litre)")
                {

                    trigger OnValidate()
                    begin
                        //"Total Fuel Issued" := "Issued Fuel (Litre)" + "Issued Fuel Add. (Litre)" ;
                        "Amount (Rs.)" := (("Issued Fuel (Litre)" + "Issued Fuel Add. (Litre)") * "Rate (Rs.)");
                    end;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field("Petrol Pump Code"; "Petrol Pump Code")
                {
                }
                field("Petrol Pump Name 1"; "Petrol Pump Name")
                {
                }
                field("Issued Coupon No."; "Issued Coupon No.")
                {
                }
                field("Fuel Type"; "Fuel Type")
                {
                }
                field("Rate (Rs.)"; "Rate (Rs.)")
                {
                }
                field("Amount (Rs.)"; "Amount (Rs.)")
                {
                }
                field("Purpose of Travel"; "Purpose of Travel")
                {
                    Caption = 'Purpose Of Issue';
                }
            }
            group(CouponInfo1)
            {
                Caption = 'Coupon Information';
                Visible = GblShowOthersCoupon;
                field("Issued Fuel (Litre) 1"; "Issued Fuel (Litre)")
                {

                    trigger OnValidate()
                    begin
                        "Amount (Rs.)" := (("Issued Fuel (Litre)" + "Issued Fuel Add. (Litre)") * "Rate (Rs.)");
                        //"Total Fuel Issued" := "Issued Fuel (Litre)" + "Issued Fuel Add. (Litre)" ;
                    end;
                }
                field("Issued Fuel Add. (Litre) 1"; "Issued Fuel Add. (Litre)")
                {
                    Caption = 'Issued Fuel Add. (Litre)';

                    trigger OnValidate()
                    begin
                        //"Total Fuel Issued" := "Issued Fuel (Litre)" + "Issued Fuel Add. (Litre)" ;
                        "Amount (Rs.)" := (("Issued Fuel (Litre)" + "Issued Fuel Add. (Litre)") * "Rate (Rs.)");
                    end;
                }
                field("Unit of Measure 1"; "Unit of Measure")
                {
                }
                field("Petrol Pump Code 1"; "Petrol Pump Code")
                {
                    Caption = 'Petrol Pump Code 1';
                }
                field("Petrol Pump Name"; "Petrol Pump Name")
                {
                }
                field("Issued Coupon No. 1"; "Issued Coupon No.")
                {
                }
                field("Fuel Type 1"; "Fuel Type")
                {
                }
                field("Rate (Rs.) 1"; "Rate (Rs.)")
                {
                }
                field("Amount (Rs.) 1"; "Amount (Rs.)")
                {
                    Caption = '<Amount (Rs.) 1';
                }
                field("Purpose Of Issue 1"; "Purpose of Travel")
                {
                    Caption = 'Purpose Of Issue';
                }
            }
            group(AddFuelIssInfo)
            {
                Caption = 'Additional Fuel Issue Information';
                Visible = GblShowAddCity;
                field("Add. From City Code"; "Add. From City Code")
                {
                }
                field("Add. From City Name"; "Add. From City Name")
                {
                }
                field("Add. To City Name"; "Add. To City Name")
                {
                }
                field("Add. Distance"; "Add. Distance")
                {
                }
                field("Add. Litre"; "Add. Litre")
                {
                }
                field("Add. Litre (Add.)"; "Add. Litre (Add.)")
                {
                }
            }
        }
        area(factboxes)
        {
            part(; 33019998)
            {
                SubPageLink = Document Type=FIELD(Document Type),
                              No.=FIELD(No.);
            }
            part(;33019999)
            {
                SubPageLink = Document Type=FIELD(Document Type),
                              No.=FIELD(No.);
            }
            systempart(;Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(PostingActionGroup)
            {
                Caption = 'Posting';
                action(Post_Coupon)
                {
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ShortCutKey = 'F9';
                    Visible = false;

                    trigger OnAction()
                    var
                        ConfirmPost: Boolean;
                        Text33019961: Label 'Do you want to post - Fuel Issue Coupon?';
                        Text33019962: Label 'Aborted by user - %1!';
                        LclDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance";
                    begin
                        //Call function to check for approval. Without approval donot let post.
                        GblDocAppPostCheck.checkDocApproval(DATABASE::"CC Memo Header",LclDocType::"Fuel Issue","No.",'Fuel Issue');

                        //Calling codeunit 33019961 to post Fuel Issue Entry without printing.
                        ConfirmPost := DIALOG.CONFIRM(Text33019961,TRUE);
                        IF ConfirmPost THEN
                          CODEUNIT.RUN(CODEUNIT::"Fuel Issue - Post",Rec)
                        ELSE
                          MESSAGE(Text33019962,USERID);
                    end;
                }
                action(Post_Print_Coupon)
                {
                    Caption = 'Post and Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    var
                        ConfirmPost: Boolean;
                        Text33019963: Label 'Do you want to post - Fuel Issue Coupon?';
                        Text33019964: Label 'Aborted by user - %1!';
                        LclDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance";
                    begin
                        //Call function to check for approval. Without approval donot let post.
                        GblDocAppPostCheck.checkDocApproval(DATABASE::"Fuel Issue Entry",LclDocType::"Fuel Issue","No.",'Fuel Issue');

                        //Calling codeunit 33019964 to post Fuel Issue Entry with printing.
                        ConfirmPost := DIALOG.CONFIRM(Text33019963,TRUE);
                        IF ConfirmPost THEN
                          CODEUNIT.RUN(CODEUNIT::"Fuel Issue - Post + Print",Rec)
                        ELSE
                          MESSAGE(Text33019964,USERID);
                    end;
                }
            }
            group("Function")
            {
                Caption = 'Function';
                action(SendAppReq)
                {
                    Caption = 'Send Approval Request';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Calling function to send approval request.
                        GblDocAppMngt.sendAppReqFuelIssue(DATABASE::"Fuel Issue Entry",GblDocType::"Fuel Issue","No.",GblEntryType::Coupon);
                    end;
                }
                action(CancelAppReq)
                {
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Calling function to cancel approval request.
                        GblDocAppMngt.cancelAppReqFuelIssue(DATABASE::"Fuel Issue Entry",GblDocType::"Fuel Issue","No.",GblEntryType::Coupon);
                    end;
                }
            }
        }
        area(reporting)
        {
            group(Documents)
            {
                Caption = 'Documents';
                action(Fuel_Coupon)
                {
                    Caption = 'Coupon';
                    Image = PrintDocument;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        FuelIssueEntry: Record "33019963";
                    begin
                        //Viewing report with filter of selected document.
                        FuelIssueEntry.RESET;
                        FuelIssueEntry.SETRANGE("Document Type","Document Type");
                        FuelIssueEntry.SETRANGE("No.","No.");
                        REPORT.RUN(33019961,TRUE,TRUE,FuelIssueEntry);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //Setting responsibility center user wise.
        UserSetup.GET(USERID);
        IF UserSetup."Apply Rules" THEN BEGIN
          IF (UserSetup."Default Responsibility Center" <> '') THEN BEGIN
            FILTERGROUP(0);
            SETFILTER("Responsibility Center",UserSetup."Default Responsibility Center");
            FILTERGROUP(2);
          END;
        END;

        ShowHidePageTabs;
    end;

    var
        UserSetup: Record "91";
        GblDocAppMngt: Codeunit "33019915";
        GblDocAppPostCheck: Codeunit "33019916";
        GblDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll;
        GblEntryType: Option " ",Coupon,Stock,Cash,CVD,PCD,Requisition,Summary;
        [InDataSet]
        GblShowStaff: Boolean;
        [InDataSet]
        GblShowDept: Boolean;
        [InDataSet]
        GblShowSales: Boolean;
        [InDataSet]
        GblShowOther: Boolean;
        [InDataSet]
        GblShowAddCity: Boolean;
        [InDataSet]
        GblShowOthersCoupon: Boolean;
        [InDataSet]
        GblShowCoupon: Boolean;
        [InDataSet]
        GblDname: Boolean;
        GblGetInfo: Record "33019963";
        GblGetKMPostTable: Record "33019967";
        GblDiffKM: Decimal;

    [Scope('Internal')]
    procedure ShowHidePageTabs()
    begin
          GblShowDept := FALSE;
          GblShowStaff := FALSE;
          GblShowOthersCoupon := FALSE;
          GblShowSales := FALSE;
          GblShowCoupon := TRUE;
          GblShowOther := FALSE;

        IF ("Issue Type" = "Issue Type"::Staff) THEN BEGIN
          GblShowStaff := TRUE;
          GblShowOthersCoupon := TRUE;
          GblShowCoupon := FALSE
        END
        ELSE IF ("Issue Type" = "Issue Type"::Department) THEN BEGIN
          GblShowDept := TRUE;
          GblShowOthersCoupon := TRUE;
          GblShowCoupon := FALSE
        END
        ELSE IF ("Issue Type" = "Issue Type"::Sales) THEN
          GblShowSales := TRUE
        ELSE IF ("Issue Type" = "Issue Type"::Others) THEN BEGIN
          GblShowOther := TRUE;
          GblShowOthersCoupon := TRUE;
          GblShowCoupon := FALSE
        END
        ELSE BEGIN
          GblShowDept := FALSE;
          GblShowStaff := FALSE;
          GblShowOthersCoupon := FALSE;
          GblShowSales := FALSE;
          GblShowCoupon := TRUE;
          GblShowOther := FALSE;
        END ;

        IF "Add Additional City" = TRUE THEN
         IF ("Issued For" = "Issued For"::Vehicle) THEN BEGIN
          GblShowAddCity := TRUE ;
          IF ("Issue Type" = "Issue Type"::Sales) THEN BEGIN
          //MESSAGE('ERRR123');
         "Add. From City Code" := "To City Code";
         "Add. From City Name" := "To City Name";
          END
          ELSE BEGIN
         "Add. From City Code" :='';
         "Add. From City Name" :='';
          END;
         END
         ELSE
         //MESSAGE('err02')
          GblShowAddCity := FALSE
        ELSE
          GblShowAddCity := FALSE;
    end;

    [Scope('Internal')]
    procedure ShowAddInfo()
    begin
         IF "Issued For" = "Issued For"::Vehicle THEN
          IF "Add Additional City" = TRUE THEN
           // MESSAGE('merr1')
           GblShowAddCity :=TRUE
          ELSE
           // MEssage('merr2')
           GblShowAddCity := FALSE
         ELSE
           GblShowAddCity := FALSE
    end;

    [Scope('Internal')]
    procedure CalculateDiffkm()
    begin
         IF "VIN (Chasis No.)" <>'' THEN
          BEGIN
           // GblGetKMPostTable.GET(GblGetKMPostTable."VIN (Chasis No.)");
            GblGetKMPostTable.SETRANGE(GblGetKMPostTable."VIN (Chasis No.)","VIN (Chasis No.)");
            IF GblGetKMPostTable.FIND('+') THEN
            BEGIN
            GblDiffKM := ("Kilometerage (KM)" - GblGetKMPostTable."Kilometerage (KM)");

            END
            ELSE
            GblDiffKM := ("Kilometerage (KM)" - 0);
          END;
    end;
}

