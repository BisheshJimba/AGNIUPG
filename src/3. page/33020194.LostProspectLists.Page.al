page 33020194 "Lost Prospect Lists"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Table33020153;

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
                field(Desription; Desription)
                {
                    Editable = false;
                }
                field(Date; Date)
                {
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
        gblLostProspect.RESET;
        gblLostProspect.SETRANGE("Prospect No.", "Prospect No.");
        IF NOT gblLostProspect.FIND('-') THEN BEGIN
            gblCRMMstTemp.RESET;
            gblCRMMstTemp.SETFILTER("Master Options", 'LostProspect');
            gblCRMMstTemp.SETRANGE(Active, TRUE);
            IF gblCRMMstTemp.FIND('-') THEN BEGIN
                REPEAT
                    gblLostProspect.INIT;
                    gblLostProspect."Prospect No." := "Prospect No.";
                    gblLostProspect."Version No." := getVersionNo("Prospect No.");
                    gblLostProspect.Code := gblCRMMstTemp.Code;
                    gblLostProspect.Desription := gblCRMMstTemp.Description;
                    gblLostProspect.INSERT;
                UNTIL gblCRMMstTemp.NEXT = 0;
            END;
        END;
    end;

    var
        gblCRMMstTemp: Record "33020143";
        gblLostProspect: Record "33020153";

    [Scope('Internal')]
    procedure getVersionNo(PrmProspectNo: Code[20]): Integer
    var
        lclLostProspect: Record "33020153";
    begin
        //Returns version no. for prospect lost sales. - It can be multiple lost for single prospect.
        lclLostProspect.RESET;
        lclLostProspect.SETRANGE("Prospect No.", PrmProspectNo);
        IF lclLostProspect.FIND('+') THEN
            EXIT(lclLostProspect."Version No." + 1)
        ELSE
            EXIT(1);
    end;
}

