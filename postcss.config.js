module.exports = {
  plugins: [
    require("postcss-import"),
    require("tailwindcss"),
    require("postcss-url")({
      url: "copy", // フォントを出力先にコピー
      assetsPath: "assets", // public/assets に出力
      useHash: true,
    }),
    require("autoprefixer"),
  ],
};
