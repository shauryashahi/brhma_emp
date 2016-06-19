class EmployersController < ApplicationController
  before_action :set_employer, only: [:show, :edit, :update, :destroy, :send_otp, :verify_otp, :phone_verification, :resend_email]

  # GET /employers
  # GET /employers.json
  def index
    @employers = Employer.all
  end

  # GET /employers/1
  # GET /employers/1.json
  def show
  end

  # GET /employers/new
  def new
    @employer = Employer.new
  end

  # GET /employers/1/edit
  def edit
  end

  def phone_verification
  end

  def resend_email
    @employer.send_verification_mail
    respond_to do |format|
      format.html { redirect_to @employer, notice: 'Please Check your email.' }
      format.json { render :show, status: :ok, location: @employer}
    end
  end

  # POST /employers
  # POST /employers.json
  def create
    @employer = Employer.new(employer_params)

    respond_to do |format|
      if @employer.save
        @employer.send_verification_mail
        @employer.send_otp
        format.html { redirect_to phone_verification_employer_path(@employer), notice: 'Employer was successfully created. Please confirm your email address to continue' }
        format.json { render :show, status: :created, location: @employer }
      else
        format.html { render :new }
        format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employers/1
  # PATCH/PUT /employers/1.json
  def update
    respond_to do |format|
      if @employer.update(employer_params)
        format.html { redirect_to @employer, notice: 'Employer was successfully updated.' }
        format.json { render :show, status: :ok, location: @employer }
      else
        format.html { render :edit }
        format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def confirm_email
    respond_to do |format|
      employer = Employer.find_by_confirm_token(params[:id])
      if employer
        employer.email_activate
        format.html { redirect_to employer, notice: 'Email Verified.' }
        format.json { render :show, status: :ok, location: employer }
      else
        format.html { redirect_to root_url }
        format.json { render json: employer.errors, status: 400 }
      end
    end
  end

  def verify_otp
    respond_to do |format|
      if @employer.verify_otp(params[:otp])
        format.html { redirect_to @employer, notice: 'Phone Verified.' }
        format.json { render :show, status: :ok, location: @employer }
      else
        format.html { redirect_to phone_verification_employer_path(@employer), notice: 'Verification Code NOT Valid' }
        format.json { render json: @employer.errors, status: 400 }
      end
    end
  end

  # DELETE /employers/1
  # DELETE /employers/1.json
  def destroy
    @employer.destroy
    respond_to do |format|
      format.html { redirect_to employers_url, notice: 'Employer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employer
      @employer = Employer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employer_params
      params.require(:employer).permit(:name, :email, :date_of_birth, :gender, :location, :phone_number)
    end
end
