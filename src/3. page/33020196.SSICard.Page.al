page 33020196 "SSI Card"
{
    Caption = 'Sales Satisfaction Index';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Attachment';
    RefreshOnActivate = true;
    SourceTable = Table33020156;

    layout
    {
        area(content)
        {
            group(General)
            {
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
                field("Registration No."; "Registration No.")
                {
                }
                field("Bill No."; "Bill No.")
                {
                }
            }
            part(Details; 33020197)
            {
                Caption = 'Details';
                SubPageLink = Prospect No.=FIELD(Prospect No.);
            }
            group("Please Mention")
            {
                Caption = 'Please Mention';
                field("Birthday Date"; "Birthday Date")
                {
                }
                field("Anniversary Date"; "Anniversary Date")
                {
                }
                field("Recom. 1 Addr."; "Recom. 1 Addr.")
                {
                }
                field("Recom. 1 Mobile"; "Recom. 1 Mobile")
                {
                }
                field("Recom. 2 Addr."; "Recom. 2 Addr.")
                {
                }
                field("Recom. 2 Mobile"; "Recom. 2 Mobile")
                {
                }
                field("Definitely Recom."; "Definitely Recom.")
                {
                    Caption = 'Definitely Recommend';
                }
                field("SW Recom."; "SW Recom.")
                {
                    Caption = 'Some What Recommend';
                }
                field("MN Recom."; "MN Recom.")
                {
                    Caption = 'May Not Recommend';
                }
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
                action(ImportSSIDoc)
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
                        gblFileName := gblRBAutoMngt.BLOBImport(gblBLOBRef, gblImportFromFile);
                        IF gblFileName <> '' THEN BEGIN
                            gblSSIAttachment.INIT;
                            gblSSIAttachment."Attachment Type" := gblSSIAttachment."Attachment Type"::SSI;
                            gblSSIAttachment."Prospect No." := "Prospect No.";
                            gblSSIAttachment.Attachment := gblBLOBRef.Blob;
                            gblSSIAttachment."File Name" := "Prospect No." + '_SSI';
                            gblSSIAttachment."File Extension" := getFileExtension(gblFileName);
                            gblSSIAttachment.INSERT;
                            MESSAGE(Text33020142);
                        END;

                        RESET;
                    end;
                }
                action(OpenSSIDoc)
                {
                    Caption = 'Open';
                    Image = TeamSales;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Exports picture to temporary location of operating system and shows the picture.
                        gblSSIAttachment.RESET;
                        gblSSIAttachment.SETFILTER("Attachment Type", 'SSI');
                        gblSSIAttachment.SETRANGE("Prospect No.", "Prospect No.");
                        IF gblSSIAttachment.FIND('-') THEN BEGIN
                            gblSSIAttachment.CALCFIELDS(Attachment);
                            IF gblSSIAttachment.Attachment.HASVALUE THEN BEGIN
                                gblFileName := TEMPORARYPATH + gblSSIAttachment."File Name" + '.' + gblSSIAttachment."File Extension";
                                gblExportToFile := gblSSIAttachment.Attachment.EXPORT(gblFileName);
                                HYPERLINK(gblFileName);
                                //DeleteFile(gblFileName); //This does not work in RTC environment.
                            END;
                        END ELSE
                            MESSAGE(Text33020149);
                    end;
                }
                action(ExportSSIDoc)
                {
                    Caption = 'Export';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Here file is exported to the specified location by the user.
                        gblSSIAttachment.RESET;
                        gblSSIAttachment.SETFILTER("Attachment Type", 'SSI');
                        gblSSIAttachment.SETRANGE("Prospect No.", "Prospect No.");
                        IF gblSSIAttachment.FIND('-') THEN BEGIN
                            gblSSIAttachment.CALCFIELDS(Attachment);
                            IF gblSSIAttachment.Attachment.HASVALUE THEN BEGIN
                                gblBLOBRef.Blob := gblSSIAttachment.Attachment;
                                IF gblExportToFile = '' THEN BEGIN
                                    gblFileFilter := gblSSIAttachment."File Extension" + ' ';
                                    gblFileFilter := gblFileFilter + '(*' + gblSSIAttachment."File Extension" + ')|*.' + gblSSIAttachment."File Extension";
                                    gblFileName := gblSSIAttachment."File Name" + '.' + gblSSIAttachment."File Extension";
                                    //gblFileName := gblCommonDialogMgt.OpenFile(Text33020143,gblFileName,4,gblFileFilter,1);commented because codeunit cannot be found Sulav
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
                action(DeleteSSIDoc)
                {
                    Caption = 'Delete';
                    Image = Delete;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Code to delete Picture record.
                        gblConfirmDelete := DIALOG.CONFIRM(Text33020146, FALSE);

                        IF gblConfirmDelete THEN BEGIN
                            gblSSIAttachment.RESET;
                            gblSSIAttachment.SETFILTER("Attachment Type", 'SSI');
                            gblSSIAttachment.SETRANGE("Prospect No.", "Prospect No.");
                            IF gblSSIAttachment.FIND('-') THEN BEGIN
                                gblSSIAttachment.DELETE;
                                MESSAGE(Text33020150);
                            END ELSE
                                MESSAGE(Text33020149);
                        END ELSE
                            MESSAGE(Text33020147, USERID);

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
        gblSSIAttachment: Record "33020196";
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
        gblNAVInStream: InStream;

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
        WHILE COPYSTR(PrmFileName, i, 1) <> '.' DO
            i := i - 1;
        EXIT(COPYSTR(PrmFileName, i + 1, STRLEN(PrmFileName) - i));
    end;
}

