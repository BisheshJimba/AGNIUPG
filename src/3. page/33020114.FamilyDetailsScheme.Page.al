page 33020114 "Family Details (Scheme)"
{
    AutoSplitKey = true;
    PageType = List;
    SourceTable = Table33019970;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Name)
                {
                }
                field(Gender; Gender)
                {
                }
                field(Grade; Grade)
                {
                }
                field("Qualified for Scholorship"; "Qualified for Scholorship")
                {

                    trigger OnValidate()
                    begin
                        IF "Qualified for Scholorship" THEN
                            AmtEditable := TRUE
                        ELSE
                            AmtEditable := FALSE;
                    end;
                }
                field("Scholorship Amount"; "Scholorship Amount")
                {
                    Enabled = AmtEditable;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        IF "Qualified for Scholorship" THEN
            AmtEditable := TRUE
        ELSE
            AmtEditable := FALSE;
    end;

    var
        [InDataSet]
        AmtEditable: Boolean;
}

