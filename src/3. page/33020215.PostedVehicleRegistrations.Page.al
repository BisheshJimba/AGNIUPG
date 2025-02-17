page 33020215 "Posted Vehicle Registrations"
{
    CardPageID = "Posted Veh. Registration Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = Table33020173;
    SourceTableView = WHERE(Registered = FILTER(Yes),
                            Completely Registered=FILTER(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                }
                field("Agent Code";"Agent Code")
                {
                }
                field(Name;Name)
                {
                }
                field(Address;Address)
                {
                }
                field("Phone No.";"Phone No.")
                {
                }
                field(Description;Description)
                {
                }
                field("Document Date";"Document Date")
                {
                }
                field("Posting Date";"Posting Date")
                {
                }
                field(Registered;Registered)
                {
                }
                field("Assigned User ID";"Assigned User ID")
                {
                }
                field("Purchase Order Created";"Purchase Order Created")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(;Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1102159014>")
            {
                Caption = '&Create Purchase Order';
                Image = CreatePutAway;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    Text000: Label 'Do you want to create Purchase Order.';
                begin
                    TESTFIELD("No.");
                    IF CONFIRM(Text000,TRUE) THEN
                      CreatePurchOrder(Rec);
                end;
            }
            action("<Action1000000002>")
            {
                Caption = '&Requisition';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //REPORT.RUN(33020023);

                    VehRegHdr.RESET;
                    VehRegHdr.SETRANGE("No.","No.");
                    VehRegHdr.SETRANGE("Posting Date","Posting Date");
                    REPORT.RUN(33020023,TRUE,TRUE,VehRegHdr);
                end;
            }
            action("&Settlement")
            {
                Caption = '&Settlement';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                begin
                    VehRegHdr.RESET;
                    VehRegHdr.SETRANGE("No.","No.");
                    VehRegHdr.SETRANGE("Posting Date","Posting Date");
                    REPORT.RUNMODAL(33020045,TRUE,TRUE,VehRegHdr);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        FILTERGROUP(3);
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
          FILTERGROUP(2);
          IF UserMgt.DefaultResponsibility THEN
            SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter())
          ELSE
            SETRANGE("Accountability Center",UserMgt.GetPurchasesFilter());
          FILTERGROUP(0);
        END;
    end;

    var
        UserMgt: Codeunit "5700";
        VehRegHdr: Record "33020173";
}

