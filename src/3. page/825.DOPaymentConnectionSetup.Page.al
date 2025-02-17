page 825 "DO Payment Connection Setup"
{
    Caption = 'Microsoft Dynamics ERP Payment Services Connection Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "DO Payment Connection Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Active; Rec.Active)
                {
                }
                field("Run in Test Mode"; Rec."Run in Test Mode")
                {
                }
                field("Service ID"; Rec."Service ID")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(SignUpNowAction)
                {
                    Caption = 'Sign up Now';
                    Ellipsis = true;
                    Image = SignUp;

                    trigger OnAction()
                    begin
                        SignUp;
                    end;
                }
                action(ManageAccountAction)
                {
                    Caption = 'Manage Account';
                    Ellipsis = true;
                    Image = EditCustomer;

                    trigger OnAction()
                    begin
                        ManageAccount;
                    end;
                }
                action(DisassociateAccountAction)
                {
                    Caption = 'Disassociate Account';
                    Ellipsis = true;
                    Image = UnLinkAccount;
                    MESSAGE(UnlinkMessage);
                    end;
                }
            }
            group(EncryptionActionGroup)
            {
                Caption = 'Encryption';
                action(GenerateKeyAction)
                {
                    Caption = 'Generate Key';
                    Image = CreateDocument;
                            IF NOT CONFIRM(OverwriteExistingKeyWarning) THEN
                                EXIT;

                        DOEncryptionMgt.CreateKey;
                        MESSAGE(KeyGeneratedMessage);
                    end;
                }
                action(DeleteKeyAction)
                {
                    Caption = 'Delete Key';
                    Image = Delete;
                            ERROR(KeyDoesNotExistError);

                        IF NOT CONFIRM(DeleteKeyWarning) THEN
                            EXIT;

                        DOEncryptionMgt.DeleteKey;
                        MESSAGE(KeyDeletedMessage);
                    end;
                }
                action(ExportKeyAction)
                {
                    Caption = 'Download Key';
                    Image = Export;

                    trigger OnAction()
                    var
                        FileMgt: Codeunit "419";
                        StdPasswordDialog: Page "9815";
                                               ServerFilename: Text;
                                               ClientFilename: Text;
                                               PasswordText: Text;
                    begin
                        ServerFilename := FileMgt.ServerTempFileName('key');
                        StdPasswordDialog.EnableBlankPassword(FALSE);
                        IF StdPasswordDialog.RUNMODAL = ACTION::OK THEN
                            PasswordText := StdPasswordDialog.GetPasswordValue
                        ELSE
                            EXIT;

                        DOEncryptionMgt.Export(ServerFilename, PasswordText);
                        ClientFilename := 'Encryption.key';
                        IF DOWNLOAD(ServerFilename, '', '', '', ClientFilename) THEN;
                        ERASE(ServerFilename);
                    end;
                }
                action(ImportKeyAction)
                {
                    Caption = 'Upload Key';
                    Image = Import;

                    trigger OnAction()
                    var
                        StdPasswordDialog: Page "9815";
                                               ServerFilename: Text;
                                               PasswordText: Text;
                    begin
                        IF UPLOAD('', '', '', '', ServerFilename) THEN BEGIN
                            StdPasswordDialog.EnableBlankPassword(TRUE);
                            IF StdPasswordDialog.RUNMODAL = ACTION::OK THEN
                                PasswordText := StdPasswordDialog.GetPasswordValue
                            ELSE
                                EXIT;

                            IF DOEncryptionMgt.HasKey THEN
                                IF NOT CONFIRM(OverwriteExistingKeyWarning) THEN
                                    EXIT;

                            DOEncryptionMgt.Import(ServerFilename, PasswordText);
                        END;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        CreateDefaultSetup;
    end;

    var
        DOEncryptionMgt: Codeunit "824";
        OverwriteExistingKeyWarning: Label 'Changing the key may render existing data unreadable. Do you want to continue?';
        DeleteKeyWarning: Label 'Deleting the key will render existing data unreadable. Do you want to continue?';
        KeyDoesNotExistError: Label 'Encryption key does not exist.';
        KeyDeletedMessage: Label 'Encryption key was successfully deleted.';
        KeyGeneratedMessage: Label 'Encryption key was successfully generated.';
        UnlinkMessage: Label 'Disassociation of the account has succeeded.';
}

