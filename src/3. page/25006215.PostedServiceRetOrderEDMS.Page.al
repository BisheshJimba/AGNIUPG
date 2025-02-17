page 25006215 "Posted Service Ret.Order EDMS"
{
    // 18.01.2017 EB.P7 Upgrade 2017
    //   Removed functionality from "Credit Cards Transaction Lo&g Entries" action
    //   because of standard page removed.
    // 
    // 23.02.2015 EDMS P21
    //   Added field:
    //     "Model Version No."
    // 
    // 2012.07.31 EDMS P8
    //   * added fields: Variable Field Run 2, Variable Field Run 3

    Caption = 'Posted Service Return Order';
    Editable = false;
    InsertAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = Table25006154;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Sell-to Contact No."; "Sell-to Contact No.")
                {
                    Editable = false;
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                    Editable = false;
                }
                field("Sell-to Address"; "Sell-to Address")
                {
                    Editable = false;
                }
                field("Sell-to Address 2"; "Sell-to Address 2")
                {
                    Editable = false;
                }
                field("Sell-to Post Code"; "Sell-to Post Code")
                {
                    Editable = false;
                }
                field("Sell-to City"; "Sell-to City")
                {
                    Editable = false;
                }
                field("Sell-to Contact"; "Sell-to Contact")
                {
                    Editable = false;
                }
                field("Posting Date"; "Posting Date")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Document Date"; "Document Date")
                {
                    Editable = false;
                }
                field("Return Order No."; "Return Order No.")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("External Document No."; "External Document No.")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                    Importance = Additional;
                }
                field(VIN; VIN)
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
                field("Variable Field Run 1"; "Variable Field Run 1")
                {
                    Visible = IsVFRun1Visible;
                }
                field("Service Advisor"; "Service Advisor")
                {
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    Editable = false;
                }
                field("No. Printed"; "No. Printed")
                {
                    Editable = false;
                }
            }
            part(ServiceLines; 25006216)
            {
                SubPageLink = Document No.=FIELD(No.);
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Bill-to Contact No."; "Bill-to Contact No.")
                {
                    Editable = false;
                }
                field("Bill-to Name"; "Bill-to Name")
                {
                    Editable = false;
                }
                field("Bill-to Address"; "Bill-to Address")
                {
                    Editable = false;
                }
                field("Bill-to Address 2"; "Bill-to Address 2")
                {
                    Editable = false;
                }
                field("Bill-to Post Code"; "Bill-to Post Code")
                {
                    Editable = false;
                }
                field("Bill-to City"; "Bill-to City")
                {
                    Editable = false;
                }
                field("Bill-to Contact"; "Bill-to Contact")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Editable = false;
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Due Date"; "Due Date")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                    Editable = false;
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code"; "Currency Code")
                {
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", "Posting Date");
                        ChangeExchangeRate.EDITABLE(FALSE);
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                            "Currency Factor" := ChangeExchangeRate.GetParameter;
                            MODIFY;
                        END;
                        CLEAR(ChangeExchangeRate);
                    end;
                }
                field("EU 3-Party Trade"; "EU 3-Party Trade")
                {
                    Editable = false;
                }
            }
            group(Details)
            {
                Caption = 'Details';
                field("Model Version No."; "Model Version No.")
                {
                }
            }
            group(Advanced)
            {
                Caption = 'Advanced';
                field("Variable Field Run 2"; "Variable Field Run 2")
                {
                    Visible = IsVFRun2Visible;
                }
                field("Variable Field Run 3"; "Variable Field Run 3")
                {
                    Visible = IsVFRun3Visible;
                }
            }
            group("Service Address")
            {
                Caption = 'Service Address';
                field("Service Address Code"; "Service Address Code")
                {
                }
                field("Service Address"; "Service Address")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Links)
            {
                Visible = false;
            }
            systempart(; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Invoice")
            {
                Caption = '&Invoice';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006240;
                    RunPageLink = No.=FIELD(No.);
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 25006187;
                                    RunPageLink = Type=CONST(Posted Service Return Order),
                                  No.=FIELD(No.);
                }
                action("<Action112>")
                {
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction()
                    begin
                        PostedApprovalEntries.Setfilters(DATABASE::"Sales Invoice Header","No.");
                        PostedApprovalEntries.RUN;
                    end;
                }
                separator()
                {
                }
                action("Credit Cards Transaction Lo&g Entries")
                {
                    Caption = 'Credit Cards Transaction Lo&g Entries';
                    Image = Translations;
                }
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
                          SalespersonCode := Rec."Service Advisor";

                        SendSMS.SetDocumentNo(Rec."No.");
                        SendSMS.SetDocumentType(3);
                        SendSMS.SetSalespersonCode(SalespersonCode);
                        SendSMS.SetContactNo(Rec."Sell-to Contact No.");
                        SendSMS.SetPhoneNo(Rec."Mobile Phone No.");
                        SendSMS.RUN;
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                    SalesInvHeader.PrintRecords(TRUE);
                end;
            }
            action("<Action59>")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        IsVFRun1Visible := IsVFActive(FIELDNO("Variable Field Run 1"));
        IsVFRun2Visible := IsVFActive(FIELDNO("Variable Field Run 2"));
        IsVFRun3Visible := IsVFActive(FIELDNO("Variable Field Run 3"));
    end;

    var
        SalesInvHeader: Record "112";
        PostedApprovalEntries: Page "659";
                                   ChangeExchangeRate: Page "511";
    [InDataSet]

    IsVFRun1Visible: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;
}

