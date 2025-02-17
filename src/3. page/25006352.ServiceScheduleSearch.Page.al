page 25006352 "Service Schedule Search"
{
    Caption = 'Service Schedule Search';

    layout
    {
        area(content)
        {
            group(Resource)
            {
                Caption = 'Resource';
                field(ResourceNo; ResourceNo)
                {
                    Caption = 'Resource No.';
                    TableRelation = Resource;
                }
            }
        }
    }

    actions
    {
    }

    var
        ResourceNo: Code[20];

    [Scope('Internal')]
    procedure TargetResourceNo(): Code[20]
    begin
        EXIT(ResourceNo);
    end;
}

