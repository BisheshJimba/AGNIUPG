page 33020234 "Vehicle Sales Comment Sheet"
{
    AutoSplitKey = true;
    Caption = 'Comment Sheet';
    DataCaptionFields = "Document Type", "No.";
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = Table33020184;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Comment; Comment)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Get Standard Terms and Conditions ")
            {
                Image = GetEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    VehTerms: Record "33020167";
                    SalesComment: Record "33020184";
                    LineNo: Integer;
                    Customer: Record "18";
                    SalesHeader: Record "36";
                begin
                    LineNo := 10000;
                    SalesHeader.RESET;
                    SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Quote);
                    SalesHeader.SETRANGE("No.", "No.");
                    IF SalesHeader.FINDFIRST THEN BEGIN
                        Customer.GET(SalesHeader."Sell-to Customer No.");
                        VehTerms.RESET;
                        VehTerms.SETRANGE("Model Code", '');
                        IF Customer."Is Dealer" THEN
                            VehTerms.SETRANGE(Type, VehTerms.Type::"Sub Dealer")
                        ELSE
                            VehTerms.SETRANGE(Type, VehTerms.Type::Individual);
                        IF VehTerms.FINDSET THEN
                            REPEAT
                                CLEAR(SalesComment);
                                SalesComment.INIT;
                                SalesComment."Document Type" := SalesComment."Document Type"::Quote;
                                SalesComment."No." := "No.";
                                SalesComment."Line No." := LineNo;
                                SalesComment.Date := TODAY;
                                SalesComment.Comment := COPYSTR(VehTerms.Term, 1, 250);
                                SalesComment.INSERT;
                                LineNo += 10000;
                            UNTIL VehTerms.NEXT = 0;
                    END;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine;
    end;
}

