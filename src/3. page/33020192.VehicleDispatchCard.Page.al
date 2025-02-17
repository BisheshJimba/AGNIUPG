page 33020192 "Vehicle Dispatch Card"
{
    PageType = Card;
    SourceTable = Table33020171;

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
                            CurrPage.UPDATE();
                    end;
                }
                field("Transfer-from Code"; "Transfer-from Code")
                {
                }
                field("Transfer-to Code"; "Transfer-to Code")
                {
                }
                field("Dispatched Date"; "Dispatched Date")
                {
                }
                field("Dispatched Time"; "Dispatched Time")
                {
                }
                field("Received Date"; "Received Date")
                {
                }
                field("Received Time"; "Received Time")
                {
                }
                field(Remarks; Remarks)
                {
                }
            }
            part(; 33020191)
            {
                SubPageLink = Document No=FIELD(No.);
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
        area(processing)
        {
            action("<Action75>")
            {
                Caption = 'P&ost';
                Ellipsis = true;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'F9';

                trigger OnAction()
                begin
                    IF DispatchVehicle(Rec) THEN
                        MESSAGE(Text002);
                end;
            }
            action("<Action76>")
            {
                Caption = 'Post and &Print';
                Ellipsis = true;
                Image = PostPrint;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+F9';

                trigger OnAction()
                var
                    DispatchHeader: Record "33020171";
                begin
                    CurrPage.SETSELECTIONFILTER(DispatchHeader);
                    IF DispatchVehicle(Rec) THEN BEGIN
                        REPORT.RUNMODAL(33020170, FALSE, FALSE, DispatchHeader);
                        MESSAGE(Text002);
                    END;
                end;
            }
        }
    }

    var
        Text002: Label 'Document posted successfully.';
}

