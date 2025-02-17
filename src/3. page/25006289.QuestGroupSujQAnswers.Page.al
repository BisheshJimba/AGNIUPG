page 25006289 "Quest. Group Suj. Q. Answers"
{
    Caption = 'Answers';
    PageType = List;
    SourceTable = Table25006210;
    SourceTableView = SORTING(Questionary Subject Group Code, Question No.,Sorting No.)
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Answer Text"; "Answer Text")
                {
                }
            }
        }
    }

    actions
    {
    }
}

