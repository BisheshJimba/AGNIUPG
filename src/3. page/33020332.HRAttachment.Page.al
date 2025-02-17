page 33020332 "HR Attachment"
{
    PageType = List;
    SourceTable = Table33020334;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Name; Name)
                {
                }
                field("File Extension"; "File Extension")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Attachments)
            {
                Caption = 'Attachments';
                action(AttOpen)
                {
                    Caption = 'Open';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        //Code written to export file to the pre specified location and then file is opened.
                        //This will export file to the user's temporary folder of the operating system and deletes the file.

                        CALCFIELDS(Attachment);
                        IF Attachment.HASVALUE THEN BEGIN
                            FileName := TEMPORARYPATH + Code + '_' + "File Extension" + '.' + "File Extension";
                            ExportToFile := Attachment.EXPORT(FileName);
                            HYPERLINK(FileName);
                            DeleteFile(FileName);
                        END;
                        MESSAGE('Success');
                    end;
                }
                action(AttExport)
                {
                    Caption = 'Export';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        //Here file is exported to the specified location by the user. By Sangam

                        CALCFIELDS(Attachment);
                        IF Attachment.HASVALUE THEN BEGIN
                            BLOBRef.Blob := Attachment;
                            IF ExportToFile = '' THEN BEGIN
                                FileFilter := "File Extension" + ' ';
                                FileFilter := FileFilter + '(*' + "File Extension" + ')|*.' + "File Extension";
                                FileName := Code + '_' + "File Extension" + '.' + "File Extension";
                                //FileName := CommonDialogMgt.OpenFile(Text001,FileName,4,FileFilter,1);
                                FileName := RBAutoMngt.OpenFileDialog(Text001, FileName, FileFilter);//pram
                                ExportToFile := BLOBRef.Blob.EXPORT(FileName);
                            END;
                        END;
                    end;
                }
                action(AttDelete)
                {
                    Caption = 'Delete';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        //Code to delete records.
                        ConfirmDelete := DIALOG.CONFIRM(Text004, FALSE);

                        IF ConfirmDelete THEN BEGIN
                            CurrPage.SETSELECTIONFILTER(Rec);
                            DELETE;
                        END ELSE
                            MESSAGE(Text005, USERID);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF "Table Name" = "Table Name"::Application THEN BEGIN
            Application.RESET;
            Application.SETRANGE("No.", Code);
            IF Application.FIND('-') THEN
                Name := Application.Initials + ' ' + Application.Name;
        END ELSE
            IF "Table Name" = "Table Name"::Employee THEN BEGIN
                Employee.RESET;
                Employee.SETRANGE("No.", Code);
                IF Employee.FIND('-') THEN
                    Name := Employee.Initials + ' ' + Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
            END;
    end;

    var
        Application: Record "33020330";
        Employee: Record "5200";
        HRAttachment: Record "33020334";
        ExportToFile: Text[250];
        BLOBRef: Record "99008535";
        FileName: Text[250];
        RBAutoMngt: Codeunit "419";
        ExportedFile: File;
        CommonDialogMgt: Codeunit "412";
        FileFilter: Text[250];
        TempPath: Text[250];
        ConfirmDelete: Boolean;
        Text000: Label '\Doc';
        Text001: Label 'Export attachment';
        Text002: Label 'All Files (*.*)|*.*';
        Text003: Label 'File exported successfully!';
        Text004: Label 'Are you sure - Delete?';
        Text005: Label 'Deletion aborted by user - %1!';
        Text006: Label 'When you have finished working with a document, you should delete the associated temporary file. Please note that this will not delete the document.\\Do you want to delete the temporary file?';

    [Scope('Internal')]
    procedure DeleteFile(FileName: Text[250]): Boolean
    var
        i: Integer;
    begin
        IF FileName = '' THEN
            EXIT(FALSE);

        IF NOT EXISTS(FileName) THEN
            EXIT(TRUE);

        REPEAT
            SLEEP(500);
            i := i + 1;
        UNTIL ERASE(FileName) OR (i = 25);
        EXIT(NOT EXISTS(FileName));
    end;
}

