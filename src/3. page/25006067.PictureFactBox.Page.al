page 25006067 "Picture FactBox"
{
    Caption = 'Picture FactBox';
    Editable = true;
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
                field(Description; Description)
                {
                    Caption = 'Description';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Select)
            {
                Caption = 'Select';
                Image = Import;

                trigger OnAction()
                begin
                    PictureMgt.BLOBImport(Rec, '');
                end;
            }
            action(Manage)
            {
                Caption = 'Manage';
                Image = ExtendedDataEntry;

                trigger OnAction()
                begin
                    PAGE.RUNMODAL(PAGE::"Picture Card", Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Picture2: Record "25006060";
    begin
    end;

    var
        PictureMgt: Codeunit "25006015";
        NextAvlbl: Boolean;
        PrevAvlbl: Boolean;
        Step: Integer;
        NotFirstRun: Boolean;
}

