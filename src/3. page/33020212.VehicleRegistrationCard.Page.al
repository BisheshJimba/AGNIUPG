page 33020212 "Vehicle Registration Card"
{
    PageType = Card;
    SourceTable = Table33020173;

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
                field("Agent Code"; "Agent Code")
                {
                }
                field(Name; Name)
                {
                }
                field(Address; Address)
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Document Date"; "Document Date")
                {
                }
            }
            part(; 33020213)
            {
                SubPageLink = Document No.=FIELD(No.);
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
                var
                    Text000: Label 'Do you want post the Document %1?';
                begin
                    IF CONFIRM(Text000, TRUE, "No.") THEN
                        PostDocument(Rec);
                end;
            }
        }
    }
}

