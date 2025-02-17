page 25006047 "Object Picture FactBox"
{
    Caption = 'Object Picture FactBox';
    CardPageID = Pictures;
    PageType = CardPart;
    SourceTable = Table25006060;
    SourceTableView = SORTING(Source Type, Source Subtype, Source ID, Source Ref. No., No.);

    layout
    {
        area(content)
        {
            group()
            {
                field(BLOB; BLOB)
                {
                    ShowCaption = false;
                }
                field("<Description>"; Description)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Previous)
            {
                Caption = 'Previous';
                Image = PreviousRecord;

                trigger OnAction()
                begin
                    ASCENDING(FALSE); //analog of NEXT(-1)
                    Step := NEXT(1);
                    ASCENDING(TRUE);
                end;
            }
            action(Next)
            {
                Caption = 'Next';
                Image = NextRecord;

                trigger OnAction()
                begin
                    Step := NEXT(1);
                end;
            }
            action(Pictures)
            {
                Caption = 'Pictures';
                RunObject = Page 25006059;
                RunPageLink = Source Type=FIELD(Source Type),
                              Source Subtype=FIELD(Source Subtype),
                              Source ID=FIELD(Source ID),
                              Source Ref. No.=FIELD(Source Ref. No.);
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Picture2: Record "25006060";
    begin
        IF (xRec."Source ID" <> Rec."Source ID") AND (Rec."Source ID" <> '') THEN BEGIN
          Picture2.RESET;
          Picture2.COPYFILTERS(Rec);
          Picture2.SETRANGE(Default, TRUE);
          IF Picture2.FINDFIRST THEN BEGIN
            GET(Picture2."No.");
            CALCFIELDS(BLOB);
          END;
        END;
    end;

    var
        PictureMgt: Codeunit "25006015";
        NextAvlbl: Boolean;
        PrevAvlbl: Boolean;
        Step: Integer;
        NotFirstRun: Boolean;
        ">---": Integer;
        ServInfoPaneMgt: Codeunit "25006104";
        [InDataSet]
        IsVFRun1Visible_fBox: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;
}

