class CounterinfosController < ApplicationController



    def create
	    @counterinfo = Counterinfo.new(thing_params)

	    respond_to do |format|
	      if @thing.save
	        format.html { redirect_to @thing, notice: 'Thing was successfully created.' }
	        format.json { render json: @thing }
	      else
	        format.html { render action: 'new' }
	        format.json { render json: @thing.errors.full_messages, status: :unprocessable_entity }
	      end
	    end
  	end

  private

    def counterinfo_params
      params.require(:counterinfo).permit(:content)
    end

end