%% Sharpening attack strength
function sharpenImageAttacked = sharpenAttack(watermarked_image)
sharpenImageAttacked = imsharpen(watermarked_image,'Radius',2,'Amount',1);
end
