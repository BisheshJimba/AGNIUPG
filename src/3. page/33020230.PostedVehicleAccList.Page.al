page 33020230 "Posted Vehicle Acc. List"
{
    CardPageID = "Posted Vehicle Acc. Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = Table33020179;
    SourceTableView = WHERE(Accessories Issued=FILTER(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                }
                field("Vehicle Serial No.";"Vehicle Serial No.")
                {
                }
                field(VIN;VIN)
                {
                }
                field("Make Code";"Make Code")
                {
                }
                field("Model Code";"Model Code")
                {
                }
                field("Model Version No.";"Model Version No.")
                {
                }
                field("Vendor Code";"Vendor Code")
                {
                }
                field("Vendor Name";"Vendor Name")
                {
                }
                field("Vendor Invoice No.";"Vendor Invoice No.")
                {
                }
                field("Customer Name";"Customer Name")
                {
                }
                field(Approved;Approved)
                {
                }
                field("Purchase Order Created";"Purchase Order Created")
                {
                }
                field("Purchase Order No.";"Purchase Order No.")
                {
                }
                field("Responsibility Center";"Responsibility Center")
                {
                }
                field("Document Date";"Document Date")
                {
                }
                field("Assigned User ID";"Assigned User ID")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1000000004>")
            {
                Caption = 'Posting';
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    ShortCutKey = 'Ctrl+o';

                    trigger OnAction()
                    begin
                        ReOpenMemo(Rec);
                    end;
                }
                action("<Action75>")
                {
                    Caption = '&Create Purchase Order';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        Text000: Label 'Do you want create the Purchase Order for Document %1?';
                        VehAccHeader: Record "33020179";
                    begin
                        //SetRecSelectionFilter(VehAccHeader);
                        IF CONFIRM(Text000,TRUE,"No.") THEN BEGIN
                          IF CreatePurchaseOrder(Rec) THEN
                            MESSAGE('Purchase Order Created successfully.');
                        END;
                    end;
                }
            }
            group("<Action1000000022>")
            {
                Caption = 'Print';
                action("Re-Print")
                {
                    Caption = 'Re-Print';

                    trigger OnAction()
                    begin
                        CurrPage.SETSELECTIONFILTER(VehAccHeader);
                        REPORT.RUNMODAL(33020176,FALSE,FALSE,VehAccHeader);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
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
        VehAccHeader: Record "33020179";

    [Scope('Internal')]
    procedure SetRecSelectionFilter(var VehAccHeader: Record "33020179")
    begin
        CurrPage.SETSELECTIONFILTER(VehAccHeader);
    end;
}

