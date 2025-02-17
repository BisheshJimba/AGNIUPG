page 14125509 "Posted Vech Serv Comparision"
{
    CardPageID = "Service DC Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = Table14125607;
    SourceTableView = WHERE(Type = CONST(Header),
                            Status = CONST(Closed));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; "Document No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                }
                field("File Name"; "File Name")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction()
                begin
                    IF NOT CONFIRM('Do you want to post the document?', FALSE) THEN
                        EXIT;
                    //Rec.TESTFIELD(Att);
                    Rec.Status := Rec.Status::Closed;
                    Rec.MODIFY;
                end;
            }
        }
    }

    local procedure createDirectory(oldPath: Text; NewDir: Text; var AttrDir: Text)
    var
        Directory: Text;
        FileMgt: Codeunit "419";
        PathHelper: DotNet Path;
        SystemDirectoryServer: DotNet Directory;
        DirectoryHelper: DotNet Directory;
    begin
        Directory := FileMgt.GetDirectoryName(oldPath);
        NewDir := DELCHR(NewDir, '=', '#%&*:<>?\/{|}~');
        IF NewDir <> '' THEN BEGIN
            Directory := PathHelper.Combine(Directory, NewDir);
            IF NOT SystemDirectoryServer.Exists(Directory) THEN
                DirectoryHelper.CreateDirectory(Directory);
        END;

        AttrDir := Directory;
    end;

    local procedure downloadAttchment(IncEntry: Integer): Boolean
    var
        tempFile: Text;
        IncommingDoc: Record "130";
    begin
        IncommingDoc.GET(IncEntry);
        IF IncommingDoc."File Name" <> '' THEN BEGIN
            tempFile := IncommingDoc."File Name";
            DOWNLOAD(IncommingDoc."File Name", 'Save as', '', '', tempFile);
            EXIT(TRUE);
        END;
    end;

    local procedure deleteAttachment(IncENt: Integer): Boolean
    var
        IncommingDoc: Record "130";
    begin
        IncommingDoc.GET(IncENt);
        IF IncommingDoc."File Name" <> '' THEN BEGIN
            ERASE(IncommingDoc."Document No.");
            IncommingDoc."File Name" := '';
            EXIT(TRUE);
        END;
        EXIT(FALSE);
    end;
}

