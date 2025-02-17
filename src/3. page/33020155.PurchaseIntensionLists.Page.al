page 33020155 "Purchase Intension Lists"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Table33020145;

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
        area(navigation)
        {
            action("<Action1102159013>")
            {
                Caption = 'Lost Sales';
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 33020194;
                RunPageLink = Prospect No.=FIELD(Prospect No.);
            }
        }
    }

    trigger OnOpenPage()
    begin
        //Inserting Purchase Intenstion.
        gblPInt.RESET;
        gblPInt.SETRANGE("Prospect No.","Prospect No.");
        IF NOT gblPInt.FIND('-') THEN BEGIN
          gblCRMMstTemp.RESET;
          gblCRMMstTemp.SETFILTER("Master Options",'PurchaseIntention');
          gblCRMMstTemp.SETRANGE(Active,TRUE);
          IF gblCRMMstTemp.FIND('-') THEN BEGIN
            REPEAT
              gblPInt.INIT;
              gblPInt."Prospect No." := "Prospect No.";
              gblPInt.Code := gblCRMMstTemp.Code;
              gblPInt.Description := gblCRMMstTemp.Description;
              gblPInt.INSERT;
            UNTIL gblCRMMstTemp.NEXT = 0;
          END;
        END;
    end;

    var
        gblCRMMstTemp: Record "33020143";
        gblPInt: Record "33020145";
}

