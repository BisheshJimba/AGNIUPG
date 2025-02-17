page 33020385 "Calendar Holidays Card"
{
    PageType = Card;
    SourceTable = Table33020371;

    layout
    {
        area(content)
        {
            group("Calendar Holidays")
            {
                field(Date; Date)
                {

                    trigger OnValidate()
                    begin
                        CalendarRec.RESET;
                        CalendarRec.SETRANGE("English Date", Date);
                        IF CalendarRec.FIND('-') THEN BEGIN
                            "Nepali Year" := CalendarRec."Nepali Year";
                            "Nepali Date" := CalendarRec."Nepali Date";
                        END
                    end;
                }
                field("Nepali Year"; "Nepali Year")
                {
                }
                field("Nepali Date"; "Nepali Date")
                {
                }
                field(Remarks; Remarks)
                {
                }
            }
            part(; 33020384)
            {
                SubPageLink = Nepali Year=FIELD(Nepali Year),
                              Day Type=CONST(Paid Holiday);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CalendarRec.RESET;
                    CalendarRec.SETRANGE(CalendarRec."English Date",Date);
                    IF CalendarRec.FIND('-') THEN BEGIN
                       CalendarRec."Day Off" := TRUE;
                       CalendarRec.Description := Remarks;
                       CalendarRec.MODIFY;
                    END
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Day Type" := "Day Type" :: "Paid Holiday";
    end;

    var
        CalendarRec: Record "33020302";
}

