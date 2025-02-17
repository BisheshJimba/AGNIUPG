page 33020156 "Motivator Lists"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Table33020146;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                field(Selected; Selected)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        //Inserting Media Motivator master data.
        gblMdMvt.RESET;
        gblMdMvt.SETRANGE("Prospect No.", "Prospect No.");
        IF NOT gblMdMvt.FIND('-') THEN BEGIN
            gblCRMMstTemp.RESET;
            gblCRMMstTemp.SETFILTER("Master Options", 'MediaMotivator');
            gblCRMMstTemp.SETRANGE(Active, TRUE);
            IF gblCRMMstTemp.FIND('-') THEN BEGIN
                REPEAT
                    gblMdMvt.INIT;
                    gblMdMvt."Prospect No." := "Prospect No.";
                    gblMdMvt.Code := gblCRMMstTemp.Code;
                    gblMdMvt.Description := gblCRMMstTemp.Description;
                    gblMdMvt.INSERT;
                UNTIL gblCRMMstTemp.NEXT = 0;
            END;
        END;
    end;

    var
        gblCRMMstTemp: Record "33020143";
        gblMdMvt: Record "33020146";
}

