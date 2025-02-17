page 25006059 Pictures
{
    Caption = 'Pictures';
    Editable = true;
    PageType = List;
    SourceTable = Table25006060;
    SourceTableView = SORTING(Source Type, Source Subtype, Source ID, Source Ref. No., No.);

    layout
    {
        area(content)
        {
            repeater()
            {
                field("No."; "No.")
                {
                }
                field("Source Type"; "Source Type")
                {
                    Caption = 'Source Type';
                    Visible = false;
                }
                field("Source Subtype"; "Source Subtype")
                {
                    Caption = 'Source Subtype';
                    Visible = false;
                }
                field("Source ID"; "Source ID")
                {
                    Caption = 'Source ID';
                    Visible = false;
                }
                field("Source Ref. No."; "Source Ref. No.")
                {
                    Caption = 'Source Ref. No.';
                    Visible = false;
                }
                field(Description; Description)
                {
                    Caption = 'Description';
                }
                field(Imported; Imported)
                {
                    Caption = 'Imported';
                    Visible = false;
                }
                field(Default; Default)
                {
                    Caption = 'Default';
                }
            }
        }
        area(factboxes)
        {
            part(Picture; 25006067)
            {
                Caption = 'Picture';
                SubPageLink = No.=FIELD(No.);
                    SubPageView = SORTING(Source Type,Source Subtype,Source ID,Source Ref. No.,No.);
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Pictures)
            {
                Caption = 'Pictures';
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        PopulateSourceFields;
    end;

    var
        PictureMgt: Codeunit "25006015";
}

