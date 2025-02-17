page 33019809 "NCHL API Log"
{
    PageType = List;
    SourceTable = Table33019809;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Id; Id)
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("API URL"; "API URL")
                {
                }
                field("API Credential Type"; "API Credential Type")
                {
                }
                field("API Authentication"; "API Authentication")
                {
                }
                field("API UserName"; "API UserName")
                {
                }
                field("API Password"; "API Password")
                {
                }
                field("API Body"; "API Body")
                {
                }
                field("Create Date Time"; "Create Date Time")
                {
                }
                field(Response; Response)
                {
                }
                field(Token; Token)
                {
                }
                field("API Method"; "API Method")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Message)
            {
                Image = Excise;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    InStr: InStream;
                    msg: Text;
                begin
                    Rec.CALCFIELDS("Response Blob");
                    IF Rec."Response Blob".HASVALUE THEN BEGIN
                        Rec."Response Blob".CREATEINSTREAM(InStr);
                        InStr.READ(msg);
                        MESSAGE(msg);
                    END;
                end;
            }
        }
    }
}

