page 33020526 "Fields Payroll"
{
    Caption = 'Fields';
    Editable = false;
    PageType = List;
    SourceTable = Table2000000041;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(TableNo; TableNo)
                {
                    Caption = 'TableNo';
                    Visible = false;
                }
                field(TableName; TableName)
                {
                    Caption = 'TableName';
                    Visible = false;
                }
                field("No."; "No.")
                {
                    Caption = 'No.';
                }
                field(FieldName; FieldName)
                {
                    Caption = 'FieldName';
                }
                field(Type; Type)
                {
                    Caption = 'Type';
                    Visible = false;
                }
                field(Class; Class)
                {
                    Caption = 'Class';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

