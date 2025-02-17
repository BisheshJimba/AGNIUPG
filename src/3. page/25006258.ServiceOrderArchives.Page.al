page 25006258 "Service Order Archives"
{
    Caption = 'Service Order Archives';
    CardPageID = "Service Order Archive";
    Editable = false;
    PageType = List;
    SourceTable = Table25006169;
    SourceTableView = WHERE(Document Type=CONST(Order));

    layout
    {
        area(content)
        {
            repeater()
            {
                field("No."; "No.")
                {
                }
                field("Version No."; "Version No.")
                {
                }
                field(s; "Date Archived")
                {
                }
                field("Time Archived"; "Time Archived")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Archived By"; "Archived By")
                {
                }
                field("Interaction Exist"; "Interaction Exist")
                {
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                }
                field("External Document No."; "External Document No.")
                {
                }
                field("Sell-to Contact"; "Sell-to Contact")
                {
                }
                field("Phone No."; "Phone No.")
                {
                    Editable = false;
                    Importance = Additional;
                }
                field("Sell-to Post Code"; "Sell-to Post Code")
                {
                }
                field("Sell-to Country/Region Code"; "Sell-to Country/Region Code")
                {
                }
                field("Bill-to Contact No."; "Bill-to Contact No.")
                {
                }
                field("Bill-to Post Code"; "Bill-to Post Code")
                {
                }
                field("Bill-to Country/Region Code"; "Bill-to Country/Region Code")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Arrival Date"; "Arrival Date")
                {
                }
                field("Service Advisor"; "Service Advisor")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Document Date"; "Document Date")
                {
                    Visible = false;
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                    Visible = false;
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    Visible = false;
                }
                field("Due Date"; "Due Date")
                {
                    Visible = false;
                }
                field("Payment Discount %"; "Payment Discount %")
                {
                    Visible = false;
                }
                field("Job Closed"; "Job Closed")
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
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ver&sion")
            {
                Caption = 'Ver&sion';
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 25006234;
                    RunPageLink = Type = CONST(Service Order),
                                  No.=FIELD(No.),
                                  Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                  Version No.=FIELD(Version No.);
                }
            }
            action(GatePass)
            {
                Caption = 'GatePass';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    STPLMgt.CreateGatePass(4,6,"No.","Sell-to Customer Name","Bill-to Name");
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        /*
        IF UserMgt.GetServiceFilterEDMS <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserMgt.GetServiceFilterEDMS);
          FILTERGROUP(0);
        END;
        *///Agni UPG 2009
        
        FilterOnRecord;

    end;

    var
        UserMgt: Codeunit "5700";
        STPLMgt: Codeunit "50000";

    [Scope('Internal')]
    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
    begin
        RespCenterFilter := UserMgt.GetServiceFilterEDMS();
        IF RespCenterFilter <> '' THEN BEGIN
          FILTERGROUP(2);
           IF UserMgt.DefaultResponsibility THEN
              SETRANGE("Responsibility Center",RespCenterFilter)
          ELSE
              SETRANGE("Accountability Center",RespCenterFilter);
          FILTERGROUP(0);
        END;
    end;
}

