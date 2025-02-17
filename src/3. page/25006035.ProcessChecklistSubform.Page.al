page 25006035 "Process Checklist Subform"
{
    AutoSplitKey = true;
    Caption = 'Inventory Checklist Subform';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = Table25006028;

    layout
    {
        area(content)
        {
            repeater()
            {
                IndentationColumn = NameIndent;
                IndentationControls = Control25006003;
                field("Process Checklist No."; "Process Checklist No.")
                {
                    Visible = false;
                }
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field("Type Code"; "Type Code")
                {
                }
                field("Type Description"; "Type Description")
                {
                }
                field(Value; Value)
                {

                    trigger OnValidate()
                    begin
                        /*ValueOnAfterValidate;*/

                    end;
                }
                field("Value Description"; "Value Description")
                {
                }
                field("Damage Remarks"; "Damage Remarks")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        /*
        CASE "Line Type" OF
          "Line Type"::"1":
            BEGIN
              NameIndent := 0;
              NameEmphasize := TRUE;
              AnswerEditable := FALSE;
            END;
          "Line Type"::"0":
            BEGIN
              NameIndent := 1;
              NameEmphasize := FALSE;
              AnswerEditable := TRUE;
            END;
          ELSE
            NameIndent := 0;
            NameEmphasize := FALSE;
            AnswerEditable := FALSE;
        END;
        */

    end;

    var
        [InDataSet]
        AnswerEditable: Boolean;
        [InDataSet]
        NameEmphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;
}

