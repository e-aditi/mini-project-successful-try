%% Gaussian Noise Attack
function GaussNoiseImageAttacked = noiseGauss(watermarked_image)
GaussNoiseImageAttacked = imnoise(watermarked_image, 'gaussian');
end