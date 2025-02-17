page 33020202 "SP Daily Visit"
{
    Caption = 'Daily Visit';
    PageType = Document;
    SourceTable = Table33020160;
    SourceTableView = ORDER(Ascending)
                      WHERE(Posted = CONST(No));

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Year; Year)
                {
                }
                field("Week No"; "Week No")
                {
                }
            }
            part(Details; 33020203)
            {
                Caption = 'Details';
                SubPageLink = Salesperson Code=FIELD(Salesperson Code),
                              Year=FIELD(Year),
                              Week No=FIELD(Week No);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1102159013>")
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Posted := TRUE;
                    MODIFY;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF Posted THEN
          CurrPage.EDITABLE(FALSE)
        ELSE
          CurrPage.EDITABLE(TRUE);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CurrPage.EDITABLE(TRUE);
    end;
}

