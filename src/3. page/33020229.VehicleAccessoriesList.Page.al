page 33020229 "Vehicle Accessories List"
{
    CardPageID = "Vehicle Accessories Card";
    PageType = List;
    ShowFilter = false;
    SourceTable = Table33020179;
    SourceTableView = WHERE(Accessories Issued=FILTER(No));

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
                field("Customer Name";"Customer Name")
                {
                }
                field(Approved;Approved)
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
                action("<Action75>")
                {
                    Caption = 'Post and &Print';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        Text000: Label 'Do you want post the Document %1?';
                    begin
                        IF CONFIRM(Text000,TRUE,"No.") THEN BEGIN
                          CurrPage.SETSELECTIONFILTER(VehAccHeader);
                          PostDocument(Rec);
                          REPORT.RUNMODAL(33020176,FALSE,FALSE,VehAccHeader);
                        END;
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Text000: Label 'Do you want to approve selected Memos?';
                        VehAcc: Record "33020179";
                    begin
                        IF CONFIRM(Text000,TRUE) THEN BEGIN
                          SetRecSelectionFilter(VehAcc);
                          IF SetLineSelection(VehAcc) THEN
                            MESSAGE('Documents approved Successfully.');
                        END;
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

