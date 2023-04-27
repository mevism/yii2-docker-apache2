<?php

use yii\db\Migration;

/**
 * Handles the creation of table `{{%userLogins}}`.
 */
class m230323_183314_create_userLogins_table extends Migration
{
    /**
     * {@inheritdoc}
     */
    public function safeUp()
    {
        $this->insert('{{%user}}', [
            'username' => 'admin',
            'auth_key' => Yii::$app->security->generateRandomString(),
            'password_hash' =>Yii::$app->security->generatePasswordHash('1234'),
            'password_reset_token' =>Yii::$app->security->generateRandomString() . time(),             
            'status' =>10 ,
            'created_at' => time(),
            'updated_at' => time(),
        ]);
    }

    /**
     * {@inheritdoc}
     */
    public function safeDown()
    {
        $this->dropTable('{{%user}}');
    }
}
