class User < ActiveRecord::Base

attr_accessor :password
 attr_accessible :email, :name, :password, :password_confirmation

 has_many :microposts, :dependent => :destroy

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :presence => true,
                   :length   => { :maximum => 50 }
  validates :email, :presence => true,
                    :format   => { :with => email_regex},
                    :uniqueness => { :case_sensitive => false }

# Автоматически создавать виртуальный атрибут 'password_confirmation'
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40}

   before_save :encrypt_password

   #Возвращает истина если пользовательский пароль совпадает с введеным
     def has_password?(submitted_password)
   #Сравнивает расшифрованный пароль с расшифрованной версией подтверждения пароля
         encrypted_password == encrypt(submitted_password)
     end

     def self.authenticate(email, submitted_password)
       user = find_by_email(email)
       return nil if user.nil?
       return user if user.has_password?(submitted_password)
     end

     def self.authenticate_with_salt(id, cookie_salt)
       user = find_by_id(id)
       #(user && user.salt == cookie_salt) ? user : nil # Тернарный оператор заменяющий конструкцию if-else
       return nil if user.nil?
       return user if user.salt == cookie_salt
     end

     def feed
       Micropost.where("user_id = ?", id)
     end

   private

     def encrypt_password
       self.salt = make_salt if new_record?
       self.encrypted_password = encrypt(password)
     end

     def encrypt(string)
       secure_hash("#{salt}--#{string}")
     end

     def make_salt
       secure_hash("#{Time.now.utc}--#{password}")
     end

     def secure_hash(string)
       Digest::SHA2.hexdigest(string)
     end
end
