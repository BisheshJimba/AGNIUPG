page 33020160 "Test Drive Card"
{
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Attachments';
    SourceTable = Table33020154;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Date; Date)
                {
                }
                field(Make; Make)
                {
                }
                field("Model No."; "Model No.")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Model Version Name"; "Model Version Name")
                {
                }
                field("Driving License No."; "Driving License No.")
                {
                }
                field("Vehicle Currenty Owned"; "Vehicle Currenty Owned")
                {
                }
                field(Views; Views)
                {
                }
                field("Considered Vehicle (Another)"; "Considered Vehicle (Another)")
                {
                }
                field("Which Vehicle"; "Which Vehicle")
                {
                }
                field(Comparision; Comparision)
                {
                }
            }
            part(; 33020161)
            {
                SubPageLink = Prospect No.=FIELD(Prospect No.),
                              Date=FIELD(Date);
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1102159032>")
            {
                Caption = 'Attachment';
                action(ImportTDrvDoc)
                {
                    Caption = 'Import';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Text33020142: Label 'Picture imported successfully!';
                    begin
                        //Code open an browser and take the input file and saves in the database.
                        //gblFileName := gblRBAutoMngt.BLOBImport(gblBLOBRef,gblImportFromFile,gblImportFromFile = '');
                        gblFileName := gblRBAutoMngt.BLOBImport(gblBLOBRef,gblImportFromFile);
                        IF gblFileName <> '' THEN BEGIN
                          gblTDAttachment.INIT;
                          gblTDAttachment."Attachment Type" := gblTDAttachment."Attachment Type"::TestDrive;
                          gblTDAttachment."Prospect No." := "Prospect No.";
                          gblTDAttachment.Attachment := gblBLOBRef.Blob;
                          gblTDAttachment."File Name" := "Prospect No." + '_TestDrive';
                          gblTDAttachment."File Extension" := getFileExtension(gblFileName);
                          gblTDAttachment.INSERT;
                          MESSAGE(Text33020142);
                        END;

                        RESET;
                    end;
                }
                action(OpenTDrvDoc)
                {
                    Caption = 'Open';
                    Image = TeamSales;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Exports picture to temporary location of operating system and shows the picture.
                        gblTDAttachment.RESET;
                        gblTDAttachment.SETFILTER("Attachment Type",'TESTDRIVE');
                        gblTDAttachment.SETRANGE("Prospect No.","Prospect No.");
                        IF gblTDAttachment.FIND('-') THEN BEGIN
                          gblTDAttachment.CALCFIELDS(Attachment);
                          IF gblTDAttachment.Attachment.HASVALUE THEN BEGIN
                            gblFileName := TEMPORARYPATH + gblTDAttachment."File Name" + '.' + gblTDAttachment."File Extension";
                            gblExportToFile := gblTDAttachment.Attachment.EXPORT(gblFileName);
                            HYPERLINK(gblFileName);
                          END;
                        END ELSE
                          MESSAGE(Text33020149);
                    end;
                }
                action(ExportTDrvDoc)
                {
                    Caption = 'Export';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Here file is exported to the specified location by the user.
                        gblTDAttachment.RESET;
                        gblTDAttachment.SETFILTER("Attachment Type",'TESTDRIVE');
                        gblTDAttachment.SETRANGE("Prospect No.","Prospect No.");
                        IF gblTDAttachment.FIND('-') THEN BEGIN
                          gblTDAttachment.CALCFIELDS(Attachment);
                          IF gblTDAttachment.Attachment.HASVALUE THEN BEGIN
                            gblBLOBRef.Blob := gblTDAttachment.Attachment;
                            IF gblExportToFile = '' THEN BEGIN
                              gblFileFilter := gblTDAttachment."File Extension" + ' ';
                              gblFileFilter := gblFileFilter + '(*' + gblTDAttachment."File Extension" + ')|*.' + gblTDAttachment."File Extension";
                              gblFileName := gblTDAttachment."File Name" + '.' + gblTDAttachment."File Extension";
                              //gblFileName := gblCommonDialogMgt.OpenFile(Text33020143,gblFileName,4,gblFileFilter,1);  because codeunit cannot be found.(Sulav)
                              gblExportToFile := gblBLOBRef.Blob.EXPORT(gblFileName);
                              MESSAGE(Text33020145);
                            END;
                          END;
                        END ELSE
                          MESSAGE(Text33020149);
                    end;
                }
                separator()
                {
                }
                action(DeleteTDrvDoc)
                {
                    Caption = 'Delete';
                    Image = Delete;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Code to delete Picture record.
                        gblConfirmDelete := DIALOG.CONFIRM(Text33020146,FALSE);

                        IF gblConfirmDelete THEN BEGIN
                          gblTDAttachment.RESET;
                          gblTDAttachment.SETFILTER("Attachment Type",'TESTDRIVE');
                          gblTDAttachment.SETRANGE("Prospect No.","Prospect No.");
                          IF gblTDAttachment.FIND('-') THEN BEGIN
                            gblTDAttachment.DELETE;
                            MESSAGE(Text33020150);
                          END ELSE
                            MESSAGE(Text33020149);
                        END ELSE
                          MESSAGE(Text33020147,USERID);

                        RESET;
                    end;
                }
            }
        }
    }

    var
        gblRBAutoMngt: Codeunit "419";
        gblFileName: Text[250];
        gblBLOBRef: Record "99008535";
        gblImportFromFile: Text[250];
        gblTDAttachment: Record "33020196";
        gblName: Text[100];
        gblExportToFile: Text[250];
        gblExportedFile: File;
        gblConfirmDelete: Boolean;
        gblCommonDialogMgt: Codeunit "412";
        gblFileFilter: Text[250];
        gblTempPath: Text[250];
        Text33020142: Label '\Doc';
        Text33020143: Label 'Export document?';
        Text33020144: Label 'All Files (*.*)|*.*';
        Text33020145: Label 'Document saved!';
        Text33020146: Label 'Are you sure - Delete?';
        Text33020147: Label 'Deletion aborted by user - %1!';
        Text33020148: Label 'When you have finished working with a document, you should delete the associated temporary file. Please note that this will not delete the document.\\Do you want to delete the temporary file?';
        Text33020149: Label 'There are no attachment for this prospect. Please upload one and try again.';
        Text33020150: Label 'Deleted!';
        gblNAVInstream: InStream;

    [Scope('Internal')]
    procedure DeleteFile(PrmFileName: Text[250]): Boolean
    var
        i: Integer;
    begin
        //Deletes file after certain time interval.
        IF PrmFileName = '' THEN
          EXIT(FALSE);

        IF NOT EXISTS(PrmFileName) THEN
          EXIT(TRUE);

        REPEAT
          SLEEP(500);
          i := i + 1;
        UNTIL ERASE(PrmFileName) OR (i = 25);
        EXIT(NOT EXISTS(PrmFileName));
    end;

    [Scope('Internal')]
    procedure getFileExtension(PrmFileName: Text[250]): Text[20]
    var
        i: Integer;
    begin
        //Retrieves imported file extension.
        i := STRLEN(PrmFileName);
        WHILE COPYSTR(PrmFileName,i,1) <> '.' DO
          i := i - 1;
        EXIT(COPYSTR(PrmFileName,i + 1,STRLEN(PrmFileName) - i));
    end;
}

