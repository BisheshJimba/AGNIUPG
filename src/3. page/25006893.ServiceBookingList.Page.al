page 25006893 "Service Booking List"
{
    Caption = 'Service Booking Worksheet';
    CardPageID = "Service Booking";
    Editable = true;
    PageType = CardPart;
    PromotedActionCategories = 'New,Process,Report,Print';
    SourceTable = Table25006145;
    SourceTableView = WHERE(Document Type=CONST(Booking));

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Requested Starting Date"; "Requested Starting Date")
                {
                }
                field("Requested Starting Time"; "Requested Starting Time")
                {
                }
                field("Requested Finishing Date"; "Requested Finishing Date")
                {
                }
                field("Requested Finishing Time"; "Requested Finishing Time")
                {
                }
                field("Total Work (Hours)"; "Total Work (Hours)")
                {
                }
                field("Deal Type"; "Deal Type")
                {
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field(Description; Description)
                {
                }
                field("Work Status Code"; "Work Status Code")
                {
                }
                field("Due Date"; "Due Date")
                {
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Service Person"; "Service Person")
                {
                }
                field("No."; "No.")
                {
                }
                field("TCard Container Entry No."; "TCard Container Entry No.")
                {
                    Visible = false;
                }
                field("Booking Resource No."; "Booking Resource No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Send SMS")
                {
                    Caption = 'Send SMS';
                    Image = SendTo;

                    trigger OnAction()
                    var
                        SendSMS: Page "25006404";
                        UserSetup: Record "91";
                        SalespersonCode: Code[10];
                    begin
                        UserSetup.GET(USERID);
                        IF UserSetup."Salespers./Purch. Code" <> '' THEN
                            SalespersonCode := UserSetup."Salespers./Purch. Code"
                        ELSE
                            SalespersonCode := Rec."Service Person";

                        SendSMS.SetDocumentNo(Rec."No.");
                        SendSMS.SetDocumentType(2);
                        SendSMS.SetSalespersonCode(SalespersonCode);
                        SendSMS.SetContactNo(Rec."Sell-to Contact No.");
                        SendSMS.SetPhoneNo(Rec."Mobile Phone No.");
                        SendSMS.RUN;
                    end;
                }
            }
            group(Create)
            {
                Caption = 'Create';
                action("<Action168>")
                {
                    Caption = 'Make &Order';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "38";
                    begin
                        CODEUNIT.RUN(CODEUNIT::"Service Booking to Order (Y/N)", Rec);
                    end;
                }
                action("<Action1102601015>")
                {
                    Caption = 'C&reate Contact';
                    Image = NewCustomer;

                    trigger OnAction()
                    begin
                        IF CheckContactCreated(FALSE) THEN
                            CurrPage.UPDATE(TRUE);
                    end;
                }
                action("<Action1102701015>")
                {
                    Caption = 'C&reate Customer';
                    Image = NewCustomer;

                    trigger OnAction()
                    begin
                        IF CheckCustomerCreated(FALSE) THEN
                            CurrPage.UPDATE(TRUE);
                    end;
                }
                action("<Action1102801015>")
                {
                    Caption = 'C&reate Vehicle';
                    Image = New;

                    trigger OnAction()
                    begin
                        IF CheckVehicleCreated(FALSE) THEN
                            CurrPage.UPDATE(TRUE);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Resources := ServiceScheduleMgt.GetRelatedResources("Document Type", "No.", ServiceLine.Type::Labor, 0, 0);
        IsVFRun1Visible := IsVFActive(FIELDNO(Kilometrage));
        //IsVFRun2Visible := IsVFActive(FIELDNO("Variable Field Run 2")); <<Bishesh Jimba 2/4/25
        //IsVFRun3Visible := IsVFActive(FIELDNO("Variable Field Run 3"));   Bishesh Jimba>>
        IsVisibleFactBox1 := ((NOT IsVFRun1Visible) AND (NOT IsVFRun2Visible) AND (NOT IsVFRun3Visible));
        IsVisibleFactBox2 := ((IsVFRun1Visible) AND (NOT IsVFRun2Visible) AND (NOT IsVFRun3Visible));
        CALCFIELDS("Schedule Start Date Time", "Schedule End Date Time");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CLEAR(Resources);
    end;

    trigger OnOpenPage()
    begin
        IF UserMgt.GetServiceFilterEDMS <> '' THEN BEGIN
            FILTERGROUP(2);
            SETRANGE("Responsibility Center", UserMgt.GetServiceFilterEDMS);
            FILTERGROUP(0);
        END;
    end;

    var
        Text001: Label 'There are non posted Prepayment Amounts on %1 %2.';
        Text002: Label 'There are unpaid Prepayment Invoices related to %1 %2.';
        ServInfoPaneMgt: Codeunit "25006104";
        ServiceScheduleMgt: Codeunit "25006201";
        ServiceLine: Record "25006146";
        ApprovalEntries: Page "658";
        [InDataSet]
        Resources: Text[250];
        UserMgt: Codeunit "5700";
        [InDataSet]
        IsVFRun1Visible: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;
        [InDataSet]
        IsVisibleFactBox1: Boolean;
        [InDataSet]
        IsVisibleFactBox2: Boolean;
        DateTimeMgt: Codeunit "25006012";

    [Scope('Internal')]
    procedure PageUpdate()
    begin
        CurrPage.UPDATE(FALSE);
    end;
}

