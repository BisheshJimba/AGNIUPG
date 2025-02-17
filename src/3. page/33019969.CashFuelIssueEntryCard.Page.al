page 33019969 "Cash-Fuel Issue Entry Card"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Posting';
    RefreshOnActivate = true;
    SourceTable = Table33019963;
    SourceTableView = WHERE(Document Type=CONST(Cash));

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
                        IF "Issue Type" = "Issue Type"::Department THEN
                            ShowDeptField := TRUE
                        ELSE
                            ShowDeptField := FALSE;

                        IF "Issue Type" = "Issue Type"::Staff THEN
                            ShowStaffInfo := TRUE
                        ELSE
                            ShowStaffInfo := FALSE;
                    end;
                }
                field(Department; Department)
                {
                    Enabled = ShowDeptField;
                }
                field("Issued For"; "Issued For")
                {

                    trigger OnValidate()
                    begin
                        IF "Issued For" = "Issued For"::Vehicle THEN
                            ShowVehInfo := TRUE
                        ELSE
                            ShowVehInfo := FALSE;
                    end;
                }
                field(Manufacturer; Manufacturer)
                {
                }
                field("Movement Type"; "Movement Type")
                {
                }
                field("Registration No."; "Registration No.")
                {
                    Caption = 'Registration No.';
                }
                field("Kilometerage (KM)"; "Kilometerage (KM)")
                {
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
                        IF "Add Additional City" THEN
                            ShowAdditional := TRUE
                        ELSE
                            ShowAdditional := FALSE;
                    end;
                }
            }
            group(Staff_Info)
            {
                Caption = 'Staff Information';
                Visible = ShowStaffInfo;
                field("Staff No."; "Staff No.")
                {
                }
                field("Staff Name"; "Staff Name")
                {
                }
            }
            group(Vehicle_Info)
            {
                Caption = 'Vehicle Information';
                Visible = ShowVehInfo;
                field("VIN (Chasis No.)"; "VIN (Chasis No.)")
                {
                    Caption = 'Chasis No.';
                }
                field("Registration No. "; "Registration No.")
                {
                    Caption = 'Registration No.';
                }
                field(Mileage; Mileage)
                {
                }
                field("Kilometerage (KM) "; "Kilometerage (KM)")
                {
                }
            }
            group(Coupon_Info)
            {
                Caption = 'Coupon Information';
                field("From City Code"; "From City Code")
                {
                }
                field("From City Name"; "From City Name")
                {
                }
                field("To City Code"; "To City Code")
                {
                }
                field("To City Name"; "To City Name")
                {
                }
                field(Distance; Distance)
                {
                }
                field("Issued Fuel (Litre)"; "Issued Fuel (Litre)")
                {
                }
                field("Issued Fuel Add. (Litre)"; "Issued Fuel Add. (Litre)")
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field("Fuel Type"; "Fuel Type")
                {
                }
                field("Purpose of Travel"; "Purpose of Travel")
                {
                }
                field("Rate (Rs.)"; "Rate (Rs.)")
                {
                }
                field("Amount (Rs.)"; "Amount (Rs.)")
                {
                }
                field("Issued To"; "Issued To")
                {
                }
            }
            group(Additional_Info)
            {
                Caption = 'Addition';
                Visible = ShowAdditional;
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
                    begin
                        //Calling codeunit 33019961 to post Fuel Issue Entry without printing.
                        ConfirmPost := DIALOG.CONFIRM(Text33019961,TRUE);
                        IF ConfirmPost THEN
                          CODEUNIT.RUN(CODEUNIT::"Fuel Issue - Post",Rec)
                        ELSE
                          MESSAGE(Text33019962,USERID);
                    end;
                }
                action(Post_Print_Cash)
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
                        Text33019961: Label 'Do you want to post - Fuel Issue Coupon?';
                        Text33019962: Label 'Aborted by user - %1!';
                    begin
                        //Calling codeunit 33019964 to post Fuel Issue Entry with printing.
                        ConfirmPost := DIALOG.CONFIRM(Text33019961,TRUE);
                        IF ConfirmPost THEN
                          CODEUNIT.RUN(CODEUNIT::"Fuel Issue - Post + Print",Rec)
                        ELSE
                          MESSAGE(Text33019962,USERID);
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
                    var
                        LclDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance";
                    begin
                        //Calling function to send approval request.
                        GblDocAppMngt.sendAppReqFuelIssue(DATABASE::"Fuel Issue Entry",GblDocType::"Fuel Issue","No.",GblEntryType::Cash);
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
                    var
                        LclDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance";
                    begin
                        //Calling function to cancel approval request.
                        GblDocAppMngt.cancelAppReqFuelIssue(DATABASE::"Fuel Issue Entry",GblDocType::"Fuel Issue","No.",GblEntryType::Cash);
                    end;
                }
            }
        }
        area(reporting)
        {
            group("<Action1102159061>")
            {
                Caption = 'Documents';
                action(Fuel_Coupon)
                {
                    Caption = 'Coupon';
                    Image = PrintDocument;
                    Promoted = true;
                    PromotedCategory = "Report";
                    Visible = false;

                    trigger OnAction()
                    var
                        FuelIssueEntry: Record "33019963";
                    begin
                        //Viewing report with filter of selected document.
                        FuelIssueEntry.RESET;
                        FuelIssueEntry.SETRANGE("Document Type","Document Type");
                        FuelIssueEntry.SETRANGE("No.","No.");
                        REPORT.RUN(33019965,TRUE,TRUE,FuelIssueEntry);
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

        IF "Issue Type" = "Issue Type"::Department THEN
          ShowDeptField := TRUE
        ELSE
          ShowDeptField := FALSE;

        IF "Issue Type" = "Issue Type"::Staff THEN
          ShowStaffInfo := TRUE
        ELSE
          ShowStaffInfo := FALSE;

        IF "Issued For" = "Issued For"::Vehicle THEN
          ShowVehInfo := TRUE
        ELSE
          ShowVehInfo := FALSE;

        IF "Add Additional City" THEN
          ShowAdditional := TRUE
        ELSE
          ShowAdditional := FALSE;
    end;

    var
        [InDataSet]
        ShowVehInfo: Boolean;
        [InDataSet]
        ShowStaffInfo: Boolean;
        [InDataSet]
        RegNoEditable: Boolean;
        [InDataSet]
        ShowAdditional: Boolean;
        [InDataSet]
        HideMovementType: Boolean;
        UserSetup: Record "91";
        [InDataSet]
        ApprovalShowHide: Boolean;
        [InDataSet]
        ShowDeptField: Boolean;
        GblDocAppMngt: Codeunit "33019915";
        GblDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll;
        GblEntryType: Option " ",Coupon,Stock,Cash,CVD,PCD,Requisition,Summary;
}

